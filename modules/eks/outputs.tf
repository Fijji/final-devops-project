output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = data.aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  value = data.aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.this.token
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc.arn
}
