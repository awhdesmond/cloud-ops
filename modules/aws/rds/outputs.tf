output "rds_hostname" {
  description = "RDS instance hostnames"
  value       = [for instance in [aws_db_instance.main, aws_db_instance.replica]: instance.address]
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.main.username
}

output "rds_password_secret_arn" {
  description = "RDS password secret arn"
  value = aws_secretsmanager_secret.password.arn
}

output "rds_password_secret_name" {
  description = "RDS password secret name"
  value = aws_secretsmanager_secret.password.name
}
