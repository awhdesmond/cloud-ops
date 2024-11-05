variable "vpc_id" {
  type        = string
  nullable    = false
  description = "ID of the VPC"
}

variable "cluster_name" {
  type        = string
  nullable    = false
  description = "Name of the DB"
}


variable "cluster_version" {
  type        = string
  default     = "7.0"
  description = "DB Engine Version"
}

variable "num_node_groups" {
  type        = number
  default     = 1
  description = "number of node groups"
}

variable "replicas_per_node_group" {
  type        = number
  default     = 1
  description = "number of cache nodes per group"
}

variable "cluster_parameter_group_name" {
  type        = string
  default     = "default.redis7.cluster.on"
  description = "parameter group name, default has cluster mode on"
}

variable "cluster_instance_class" {
  type        = string
  default     = "cache.t3.small"
  description = "node type"
}

variable "cluster_subnets_id" {
  type        = list(string)
  nullable    = false
  description = "ids of subnets to deploy the database"
}


variable "cluster_security_group_ingress_cidr_blocks" {
  type        = list(string)
  description = "database security group ingress cidr blocks"
  validation {
    condition = alltrue([
      for o in var.cluster_security_group_ingress_cidr_blocks : can(cidrnetmask(o))
    ])
    error_message = "Must be valid IPv4 CIDR block"
  }
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources."
}

