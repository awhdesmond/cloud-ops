resource "aws_ecr_repository" "main" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "name" {
  repository = aws_ecr_repository.main.name
  policy     = file(var.lifecycle_policy_file)
}
