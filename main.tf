provider "aws" { region = var.region }
data "aws_caller_identity" "current" {}



module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.azs
  vpc_name           = "fp-vpc"
}


module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_repo_name
  scan_on_push = true
}


module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  region             = var.region
}

module "jenkins" {
  source       = "./modules/jenkins"
  namespace    = var.jenkins_namespace
  release_name = var.jenkins_release
  aws_region   = var.region
  ecr_repo_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repo_name}"
  depends_on   = [module.eks]
}

module "argocd" {
  source         = "./modules/argo_cd"
  namespace      = var.argocd_namespace
  release_name   = var.argocd_release
  apps_repo_url  = var.apps_repo_url
  apps_repo_rev  = var.apps_repo_rev
  apps_repo_path = var.apps_repo_path
  app_name       = var.app_name
  app_namespace  = var.app_namespace
  depends_on     = [module.eks]
}

# RDS module (standard RDS or Aurora depending on use_aurora)
module "rds" {
  source = "./modules/rds"

  use_aurora    = var.use_aurora
  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.private_subnet_ids

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  multi_az       = var.multi_az

  database_name = var.database_name
  username      = var.db_username
  password      = var.db_password

  allocated_storage       = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  publicly_accessible     = var.publicly_accessible
  custom_port             = var.custom_port
  parameter_overrides     = var.parameter_overrides

  allowed_cidr_blocks        = var.rds_allowed_cidr_blocks
  allowed_security_group_ids = var.rds_allowed_security_group_ids

  name_prefix = var.name_prefix
  tags        = var.tags
}

module "monitoring" {
  source = "./modules/monitoring"
  namespace = var.monitoring_namespace
  grafana_admin_user = var.grafana_admin_user
  grafana_admin_password = var.grafana_admin_password
  depends_on = [module.eks]
}

