variable "vpc_id" {
  type        = string
  nullable    = false
  description = "ID of the VPC"
}

variable "db_name" {
  type        = string
  nullable    = false
  description = "Name of the DB"
}
variable "db_user" {
  type        = string
  default     = "postgres"
  description = "DB User"
}

variable "db_password" {
  type        = string
  default     = "postgres"
  description = "DB Password"
}

variable "db_engine" {
  type        = string
  nullable    = false
  description = "DB Engine"
}

variable "db_version" {
  type        = string
  nullable    = false
  description = "DB Engine Version"
}

variable "db_family" {
  type        = string
  nullable    = false
  description = "DB Family"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.small"
  description = "DB instance class"
}

variable "db_storage_type" {
  type        = string
  default     = "gp2"
  description = "DB storage type"
}

variable "db_subnets_id" {
  type        = list(string)
  nullable    = false
  description = "ids of subnets to deploy the database"
}

variable "db_storage" {
  type        = number
  nullable    = false
  description = "size of the database"
}

variable "db_security_group_ingress_cidr_blocks" {
  type        = list(string)
  description = "database security group ingress cidr blocks"
  validation {
    condition = alltrue([
      for o in var.db_security_group_ingress_cidr_blocks : can(cidrnetmask(o))
    ])
    error_message = "Must be valid IPv4 CIDR block"
  }
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources."
}

