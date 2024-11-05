output "eks_oidc_provider_url" {
  value = aws_iam_openid_connect_provider.eks.url
  description = "eks oidc provider url"
}

output "eks_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
  description = "eks oidc provider arn"
}

output "aws_lbc_role_arn" {
  value = aws_iam_role.aws_lbc.arn
  description = "aws-lbc role arn"
}
