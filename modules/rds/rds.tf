locals { create_standard = var.use_aurora == false }

resource "aws_db_instance" "this" {
  count                   = local.create_standard ? 1 : 0
  identifier              = "${var.name_prefix}-instance"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this.id]
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  deletion_protection     = var.deletion_protection
  backup_retention_period = var.backup_retention_period
  db_name                 = var.database_name
  username                = var.username
  password                = var.password
  parameter_group_name    = aws_db_parameter_group.this.name
  skip_final_snapshot     = true

  tags = merge(var.tags, { Name = "${var.name_prefix}-instance" })
}


