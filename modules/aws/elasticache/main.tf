resource "aws_elasticache_subnet_group" "main" {
  name       = var.cluster_name
  subnet_ids = var.cluster_subnets_id

  tags = merge(var.default_tags, {
    Name = var.cluster_name
  })
}

resource "aws_security_group" "main" {
  name_prefix = "elasticache-${var.cluster_name}-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.cluster_security_group_ingress_cidr_blocks
  }
}

resource "random_password" "password" {
  length           = 128
  special          = true
  override_special = "!&#$^<>-"
}

resource "aws_secretsmanager_secret" "password" {
  name = "elasticache-${var.cluster_name}-password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.password.result
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = var.cluster_name
  automatic_failover_enabled = true
  description                = "Redis cluster for ${var.cluster_name}"

  node_type               = var.cluster_instance_class
  num_node_groups         = var.num_node_groups
  replicas_per_node_group = var.replicas_per_node_group
  engine_version          = var.cluster_version
  parameter_group_name    = var.cluster_parameter_group_name

  engine = "redis"
  port   = 6379

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.main.id]

  apply_immediately          = true
  transit_encryption_enabled = true
  auth_token                 = aws_secretsmanager_secret_version.password.secret_string

  tags = merge(var.default_tags, {
    Name = var.cluster_name
  })
}
