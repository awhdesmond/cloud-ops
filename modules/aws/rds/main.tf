resource "aws_kms_key" "rds_kms_key" {
  deletion_window_in_days = 30

  tags = merge(var.default_tags, {
    Name = "RDS KMS key"
  })
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-${var.db_name}-"
  vpc_id      = var.vpc_id

  ingress {
    to_port     = 5432
    from_port   = 5432
    protocol    = "tcp"
    cidr_blocks = var.db_security_group_ingress_cidr_blocks
  }

  tags = merge(var.default_tags, {
    Name = var.db_name
  })
}

resource "aws_db_subnet_group" "main" {
  name       = var.db_name
  subnet_ids = var.db_subnets_id

  tags = merge(var.default_tags, {
    Name = var.db_name
  })
}

resource "aws_db_parameter_group" "main" {
  name   = var.db_name
  family = var.db_family

  tags = merge(var.default_tags, {
    Name = var.db_name
  })
}

resource "random_password" "master" {
  length           = 20
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  name = "rds-${var.db_name}-password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

resource "aws_db_instance" "main" {
  storage_type      = var.db_storage_type
  identifier        = var.db_name
  instance_class    = var.db_instance_class
  allocated_storage = var.db_storage
  engine            = var.db_engine
  engine_version    = var.db_version
  username          = var.db_user
  password          = aws_secretsmanager_secret_version.password.secret_string

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  backup_retention_period = 7

  parameter_group_name = aws_db_parameter_group.main.name
  skip_final_snapshot  = true
  storage_encrypted    = true
  kms_key_id           = aws_kms_key.rds_kms_key.arn

  # Enable Multi-AZ deployment for high availability
  multi_az = true

  tags = merge(var.default_tags, {
    Name = var.db_name
  })
}


resource "aws_db_instance" "replica" {
  replicate_source_db = aws_db_instance.main.identifier
  instance_class      = var.db_instance_class

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  backup_retention_period = 7
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.rds_kms_key.arn
  parameter_group_name = aws_db_parameter_group.main.name
  skip_final_snapshot  = true

  tags = merge(var.default_tags, {
    Name = var.db_name
  })
}