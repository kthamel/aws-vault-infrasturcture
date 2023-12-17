data "aws_iam_policy_document" "kthamel-eks-cluster-autoscaler-policy-document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.kthamel-eks-openid.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.kthamel-eks-openid.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "kthamel-eks-cluster-autoscaller-role" {
  assume_role_policy = data.aws_iam_policy_document.kthamel-eks-cluster-autoscaler-policy-document.json
  name               = "kthamel-eks-cluster-autoscaller-role"
}

resource "aws_iam_policy" "kthamel-eks-cluster-autoscaller-policy" {
  name = "kthamel-eks-cluster-autoscaller-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_attach" {
  role = aws_iam_role.kthamel-eks-cluster-autoscaller-role.name
  # role       = aws_iam_role.kthamel-eks_cluster_autoscaler-role.role 
  policy_arn = aws_iam_policy.kthamel-eks-cluster-autoscaller-policy.arn
}

output "eks_cluster_autoscaler_arn" {
  value = aws_iam_policy.kthamel-eks-cluster-autoscaller-policy.arn
}
