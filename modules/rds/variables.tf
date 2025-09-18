variable "use_aurora" {
  description = "Create Aurora (true) or standard RDS (false)."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID for SG"
  type        = string
}

variable "db_subnet_ids" {
  description = "Subnet IDs for DB subnet group"
  type        = list(string)
}

variable "engine" {
  description = "DB engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "DB engine version"
  type        = string
  default     = "14"
}

variable "instance_class" {
  description = "Instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "multi_az" {
  description = "Multi-AZ for standard RDS"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Initial DB name"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Master username"
  type        = string
  default     = "appuser"
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "GB for standard RDS"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Backup days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Deletion protection"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Public access"
  type        = bool
  default     = false
}

variable "allowed_cidr_blocks" {
  description = "Ingress CIDRs"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Ingress SGs"
  type        = list(string)
  default     = []
}

variable "custom_port" {
  description = "Custom DB port or null"
  type        = number
  default     = null
}

variable "parameter_overrides" {
  description = "Extra parameters"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "rds"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

