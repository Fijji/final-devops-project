region       = "us-west-2"
cluster_name = "final-eks"

vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]

ecr_repo_name = "final-django"

jenkins_namespace = "jenkins"
jenkins_release   = "jenkins"

argocd_namespace = "argocd"
argocd_release   = "argocd"
apps_repo_url    = "https://github.com/Fijji/friendly-bash/Project"
apps_repo_rev    = "main"
apps_repo_path   = "charts/django-app"
app_name         = "django-app"
app_namespace    = "default"

# RDS defaults; override as needed
use_aurora                     = false
engine                         = "postgres"
engine_version                 = "14"
instance_class                 = "db.t3.medium"
multi_az                       = false
database_name                  = "appdb"
db_username                    = "appuser"
db_password                    = "root"
allocated_storage              = 20
backup_retention_period        = 7
deletion_protection            = true
publicly_accessible            = false
custom_port                    = null
parameter_overrides            = {}
rds_allowed_cidr_blocks        = []
rds_allowed_security_group_ids = []
name_prefix                    = "rds"
tags                           = {}

# Monitoring
monitoring_namespace = "monitoring"
grafana_admin_user   = "admin"
grafana_admin_password = "admin123"



