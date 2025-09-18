locals {
  is_postgres = contains(["postgres", "aurora-postgresql"], var.engine)
  is_mysql    = contains(["mysql", "aurora-mysql"], var.engine)
  db_port     = var.custom_port != null ? var.custom_port : (local.is_postgres ? 5432 : 3306)
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags       = merge(var.tags, { Name = "${var.name_prefix}-subnet-group" })
}

resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-db-sg"
  description = "Security group for RDS/Aurora"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-db-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "cidr_ingress" {
  for_each          = toset(var.allowed_cidr_blocks)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = local.db_port
  to_port           = local.db_port
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress" {
  for_each                     = toset(var.allowed_security_group_ids)
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = each.value
  ip_protocol                  = "tcp"
  from_port                    = local.db_port
  to_port                      = local.db_port
}

resource "aws_vpc_security_group_egress_rule" "egress_all" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_db_parameter_group" "this" {
  name_prefix = "rds-param-"
  family      = "postgres14"
  description = "Parameter group for standard RDS"
  lifecycle { create_before_destroy = true }
  parameter {
    name         = "log_statement"
    value        = "none"
    apply_method = "immediate"
  }
  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "immediate"
  }
  parameter {
    name         = "work_mem"
    value        = "4096"
    apply_method = "immediate"
  }
}


resource "aws_rds_cluster_parameter_group" "this" {
  count       = var.use_aurora ? 1 : 0
  name        = "${var.name_prefix}-cluster-param"
  family      = local.is_postgres ? "aurora-postgresql${var.engine_version}" : (local.is_mysql ? "aurora-mysql${var.engine_version}" : null)
  description = "Parameter group for Aurora cluster"

  dynamic "parameter" {
    for_each = merge({
      max_connections = local.is_postgres ? "200" : "151"
      log_statement   = local.is_postgres ? "none" : null
      work_mem        = local.is_postgres ? "4096" : null
    }, var.parameter_overrides)

    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  tags = var.tags

  lifecycle { create_before_destroy = true }
}

