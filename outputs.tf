output "ecr_repo_url" {
  value       = module.ecr.repo_url
  description = "ECR repository URL"
}

output "rds_hostnames" {
  description = "RDS instance hostnames"
  value       = module.rds.rds_hostname
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.rds_port
}

output "rds_username" {
  description = "RDS instance username"
  value       = module.rds.rds_username
}

output "rds_password_secret_arn" {
  description = "RDS instance password secret arn"
  value       = module.rds.rds_password_secret_arn
}

output "rds_password_secret_name" {
  description = "RDS instance password secret name"
  value       = module.rds.rds_password_secret_name
}

output "elasticache_cluster_configuration_endpoint" {
  description = "Elasticache configuration endpoint"
  value = module.elasticache.cluster_configuration_endpoint
}

output "elasticache_cluster_password_secret_name" {
  description = "Elasticache password secret name"
  value = module.elasticache.cluster_password_secret_name
}

output "elasticache_cluster_password_secret_arn" {
  description = "Elasticache password secret arn"
  value = module.elasticache.cluster_password_secret_arn
}

output "aws_lbc_role_arn" {
  value = module.eks.aws_lbc_role_arn
  description = "aws-lbc role arn"
}
output "user_service_role_arn" {
  value = module.user_service_role.role_arn
  description = "user service role arn"
}
