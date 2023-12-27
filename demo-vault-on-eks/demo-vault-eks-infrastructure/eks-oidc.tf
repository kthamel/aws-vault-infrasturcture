data "tls_certificate" "kthamel-eks-certificate" {
  url = aws_eks_cluster.kthamel-eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "kthamel-eks-openid" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.kthamel-eks-certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.kthamel-eks-cluster.identity[0].oidc[0].issuer
}
