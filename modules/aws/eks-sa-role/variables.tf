variable "eks_name" {
  type = string
  nullable = false
  description = "EKS name"
}

variable "eks_namespace" {
  type = string
  nullable = false
  description = "EKS namespace"
}

variable "eks_service_account" {
  type = string
  nullable = false
  description = "EKS service account"
}

variable "eks_oidc_provider_url" {
  type = string
  nullable = false
  description = "EKS OIDC provider url"
}


variable "eks_oidc_provider_arn" {
  type = string
  nullable = false
  description = "EKS OIDC provider arn"
}

variable "secrets_arns" {
  type = list(string)
  nullable = false
  description = "list of secrets arns"
}
