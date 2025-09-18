variable "region" { type = string }

# VPC
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }

# ECR + EKS
variable "ecr_repo_name" { type = string }
variable "cluster_name" { type = string }

# Jenkins
variable "jenkins_namespace" {
  type    = string
  default = "jenkins"
}
variable "jenkins_release" {
  type    = string
  default = "jenkins"
}

# Argo CD
variable "argocd_namespace" {
  type    = string
  default = "argocd"
}
variable "argocd_release" {
  type    = string
  default = "argocd"
}
variable "apps_repo_url" { type = string }
variable "apps_repo_rev" {
  type    = string
  default = "main"
}
variable "apps_repo_path" { type = string }
variable "app_name" {
  type    = string
  default = "django-app"
}
variable "app_namespace" {
  type    = string
  default = "default"
}

# RDS
variable "use_aurora" {
  type    = bool
  default = false
}
variable "engine" {
  type    = string
  default = "postgres"
}
variable "engine_version" {
  type    = string
  default = "14"
}
variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}
variable "multi_az" {
  type    = bool
  default = false
}
variable "database_name" {
  type    = string
  default = "appdb"
}
variable "db_username" {
  type    = string
  default = "appuser"
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "allocated_storage" {
  type    = number
  default = 20
}
variable "backup_retention_period" {
  type    = number
  default = 7
}
variable "deletion_protection" {
  type    = bool
  default = true
}
variable "publicly_accessible" {
  type    = bool
  default = false
}
variable "custom_port" {
  type    = number
  default = null
}
variable "parameter_overrides" {
  type    = map(string)
  default = {}
}
variable "rds_allowed_cidr_blocks" {
  type    = list(string)
  default = []
}
variable "rds_allowed_security_group_ids" {
  type    = list(string)
  default = []
}
variable "name_prefix" {
  type    = string
  default = "rds"
}
variable "tags" {
  type    = map(string)
  default = {}
}

# Monitoring
variable "monitoring_namespace" {
  type    = string
  default = "monitoring"
}

variable "grafana_admin_user" {
  type    = string
  default = "admin"
}

variable "grafana_admin_password" {
  type      = string
  default   = "admin123"
  sensitive = true
}



