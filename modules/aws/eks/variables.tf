variable "vpc_id" {
  type = string
  nullable = false
  description = "VPC ID"
}

variable "eks_name" {
  type = string
  default = "eks"
  description = "Name of eks cluster"
}

variable "eks_version" {
  type = string
  default = "1.30"
  description = "EKS K8s version"
}

variable "cluster_addons" {
  description = "List of strings specifying cluster addons"
  type        = list(string)
  default     = ["vpc-cni", "kube-proxy", "coredns"]
}

variable "public_subnet_ids" {
  type        = list(string)
  nullable    = false
  description = "list of public subnets"
}

variable "private_subnet_ids" {
  type        = list(string)
  nullable    = false
  description = "list of private subnets"
}


variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources."
}
