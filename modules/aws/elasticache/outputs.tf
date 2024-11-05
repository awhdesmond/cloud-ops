output "cluster_enabled" {
  description = "Whether cluster mode is neabled"
  value       = aws_elasticache_replication_group.main.cluster_enabled
  sensitive   = true
}

output "cluster_configuration_endpoint" {
  description = "Elasticache configuration endpoint"
  value = aws_elasticache_replication_group.main.configuration_endpoint_address
}

output "cluster_password_secret_arn" {
  description = "Elasticache password secret arn"
  value = aws_secretsmanager_secret.password.arn
}

output "cluster_password_secret_name" {
  description = "Elasticache password secret arn"
  value = aws_secretsmanager_secret.password.name
}

