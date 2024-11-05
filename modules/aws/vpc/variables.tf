variable "vpc_name" {
  type        = string
  nullable    = false
  description = "Name of the VPC."
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The IPv4 CIDR block for the VPC."

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "public_subnet_count" {
  type        = number
  default     = 2
  description = "Number of public subnets."
}

variable "public_subnet_additional_bits" {
  type        = number
  default     = 2
  description = "Number of additional bits with which to extend the prefix."
}

variable "private_subnet_count" {
  type        = number
  default     = 2
  description = "Number of Private subnets."
}

variable "private_subnet_additional_bits" {
  type        = number
  default     = 2
  description = "Number of additional bits with which to extend the prefix."
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources."
}
