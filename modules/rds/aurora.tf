locals { create_aurora = var.use_aurora == true }

resource "aws_rds_cluster" "this" {
  count                           = local.create_aurora ? 1 : 0
  cluster_identifier              = "${var.name_prefix}-cluster"
  engine                          = var.engine
  engine_version                  = var.engine_version
  database_name                   = var.database_name
  master_username                 = var.username
  master_password                 = var.password
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  deletion_protection             = var.deletion_protection
  backup_retention_period         = var.backup_retention_period
  skip_final_snapshot             = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this[0].name

  tags = merge(var.tags, { Name = "${var.name_prefix}-cluster" })
}

resource "aws_rds_cluster_instance" "this" {
  count                   = local.create_aurora ? 1 : 0
  identifier              = "${var.name_prefix}-cluster-writer"
  cluster_identifier      = aws_rds_cluster.this[0].id
  instance_class          = var.instance_class
  engine                  = var.engine
  engine_version          = var.engine_version
  publicly_accessible     = var.publicly_accessible
  db_subnet_group_name    = aws_db_subnet_group.this.name
  db_parameter_group_name = aws_db_parameter_group.this.name

  tags = merge(var.tags, { Role = "writer" })
}


