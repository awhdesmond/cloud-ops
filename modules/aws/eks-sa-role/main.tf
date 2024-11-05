data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.eks_namespace}:${var.eks_service_account}"]
    }

    principals {
      identifiers = [var.eks_oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "role" {
  name               = "${var.eks_name}-user-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy" "policy" {
  name = "${var.eks_name}-${var.eks_namespace}-${var.eks_service_account}-sa-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([for arn in var.secrets_arns : {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = arn
    }])
  })
}

resource "aws_iam_role_policy_attachment" "role" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}
