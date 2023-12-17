data "aws_iam_policy_document" "kthamel-eks-iam-oidc-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.kthamel-eks-openid.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:kthamel-eks-oidc-role"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.kthamel-eks-openid.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "kthamel-eks-iam-role-oidc" {
  name               = "kthamel-eks-iam-role-oidc"
  assume_role_policy = data.aws_iam_policy_document.kthamel-eks-iam-oidc-policy.json
}

resource "aws_iam_policy" "kthamel-eks-iam-policy-oidc" {
  name = "kthamel-eks-iam-policy-oidc"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement",
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "kthamel-eks-iam-policy-attach-oidc" {
  name       = "kthamel-eks-iam-policy-attach-oidc"
  roles      = [aws_iam_role.kthamel-eks-iam-role-oidc.name]
  policy_arn = aws_iam_policy.kthamel-eks-iam-policy-oidc.arn
}

output "kthamel-eks-oidc-policy-arn" {
  value = aws_iam_role.kthamel-eks-iam-role-oidc.arn
}
