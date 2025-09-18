output "ecr_repository_url" { value = module.ecr.repository_url }
output "cluster_name" { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "vpc_id" { value = module.vpc.vpc_id }
output "region" { value = var.region }

output "rds_endpoint" { value = try(module.rds.db_endpoint, null) }
output "rds_port" { value = try(module.rds.db_port, null) }
output "rds_db_name" { value = try(module.rds.db_name, null) }

output "monitoring_namespace" { value = module.monitoring.namespace }
output "grafana_service_name" { value = module.monitoring.grafana_service_name }
output "prometheus_service_name" { value = module.monitoring.prometheus_service_name }