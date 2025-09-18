output "db_engine" { value = var.engine }
output "db_port" { value = local.db_port }
output "db_security_group_id" { value = aws_security_group.this.id }
output "db_subnet_group_name" { value = aws_db_subnet_group.this.name }
output "parameter_group_name" { value = aws_db_parameter_group.this.name }
output "cluster_parameter_group_name" { value = try(aws_rds_cluster_parameter_group.this[0].name, null) }

output "rds_instance_id" { value = try(aws_db_instance.this[0].id, null) }
output "rds_instance_endpoint" { value = try(aws_db_instance.this[0].address, null) }
output "rds_instance_port" { value = try(aws_db_instance.this[0].port, null) }

output "aurora_cluster_id" { value = try(aws_rds_cluster.this[0].id, null) }
output "aurora_reader_endpoint" { value = try(aws_rds_cluster.this[0].reader_endpoint, null) }
output "aurora_writer_endpoint" { value = try(aws_rds_cluster.this[0].endpoint, null) }

