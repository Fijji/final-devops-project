# AWS Infra з Terraform, EKS, RDS, ECR, Jenkins, Argo CD, Monitoring

Інструкція для розгортання інфраструктури в AWS з використанням Terraform і Kubernetes.

---

## Технічні вимоги

- **Інфраструктура:** AWS (IaC через Terraform)
- **Компоненти:** VPC, EKS, RDS, ECR, Jenkins, Argo CD, Prometheus, Grafana

**Потрібні інструменти:** Terraform ≥ 1.6, kubectl, helm, awscli, Docker.  
**Remote state:** S3 bucket + DynamoDB table

---

## Огляд архітектури

```
flowchart LR
  subgraph AWS[VPC (Private/Public Subnets)]
    direction LR
    IGW[Internet Gateway]
    NAT[NAT Gateway]

    subgraph Public[Public Subnets]
      JB[EC2 / Bastion (опційно)]
    end

    subgraph Private[Private Subnets]
      EKS[(EKS Cluster)]
      RDS[(RDS / Aurora)]
    end

    ECR[(ECR Registry)]
  end

  Dev[Developer / CI]
  Dev -->|git push / docker build| ECR
  ECR -->|pull image| EKS

  subgraph CI/CD
    Jenkins[Jenkins (Helm)]
    ArgoCD[Argo CD (Helm)]
  end

  EKS --> Jenkins
  Dev -->|git push apps manifests| ArgoCD
  ArgoCD -->|sync apps| EKS

  subgraph Monitoring
    Prom[Prometheus]
    Graf[Grafana]
  end

  EKS <-->|metrics| Prom
  Prom --> Graf

  IGW --- Public
  Public --- Private
  NAT --- Private
```

---

## Структура репозиторію

```
Project/
├── main.tf            # Підключення модулів
├── backend.tf         # S3 + DynamoDB для Terraform state
├── outputs.tf         # Виводи ресурсів
├── modules/
│  ├── s3-backend/     # S3/DynamoDB (якщо створюєте з Terraform)
│  ├── vpc/            # VPC, підмережі, маршрути
│  ├── ecr/            # ECR репозиторій
│  ├── eks/            # EKS + EBS CSI (IRSA)
│  ├── rds/            # RDS/Aurora + SG/IAM
│  ├── jenkins/        # Helm-реліз Jenkins
│  └── argo_cd/        # Helm-реліз Argo CD (+ charts/ для apps)
├── charts/
│  └── django-app/
│     ├── templates/ (deployment, service, hpa, configmap)
│     ├── Chart.yaml
│     └── values.yaml
└── Django/
   ├── app/
   ├── Dockerfile
   ├── Jenkinsfile
   └── docker-compose.yaml
```

---

## Етапи виконання

### 1) Підготовка середовища
```bash
git clone git@github.com:Fijji/final-devops-project.git
git checkout final-project
```

`terraform.tfvars`:
```hcl
region           = "us-west-2"
vpc_cidr         = "10.0.0.0/16"
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
azs              = ["us-west-2a", "us-west-2b"]
cluster_name     = "final-eks"
ecr_repo_name    = "final-django"
jenkins_namespace = "jenkins"
argocd_namespace  = "argocd"
app_name         = "django-app"
app_namespace    = "default"
```
---

### 2) Ініціалізація та розгортання
```bash
terraform init
terraform validate
terraform plan -out tf.plan
terraform apply tf.plan
```
---

### 3) kubeconfig та доступ до кластера
```bash
aws eks update-kubeconfig \
  --name   $(terraform output -raw cluster_name) \
  --region $(terraform output -raw region 2>/dev/null || echo us-west-2)

kubectl get nodes
```
---

### 4) Перевірка компонентів
```bash
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring || true
```
---

### 5) Порт-фарвардинг для доступу
**Jenkins**
```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```
**Argo CD**
```bash
kubectl port-forward svc/argocd-server 8081:443 -n argocd
```
**Grafana**
```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```
---

### 6) Збірка та пуш Docker-образу в ECR
```bash
export AWS_REGION=$(terraform output -raw region 2>/dev/null || echo us-west-2)
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export REPO=$(terraform output -raw ecr_repository_url)

aws ecr get-login-password --region $AWS_REGION \
| docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

docker build -t $REPO:latest Django
docker push $REPO:latest
```

---

### 7) Деплой через Argo CD
- Відкрийте Argo CD (порт 8081) → знайдіть `django-app` → **Sync**.
- Перевірте:
```bash
kubectl -n argocd rollout status deploy/argocd-server
```

---

### 8) Валідація 
```bash
kubectl get svc -A | grep django
kubectl get pods -n default
```

---

### 9) Моніторинг та метрики
- **Grafana** (порт 3000) → перевірте Prometheus/Grafana.

---

##  Cleanup
Видаліть інфраструктуру

```bash
terraform destroy
```