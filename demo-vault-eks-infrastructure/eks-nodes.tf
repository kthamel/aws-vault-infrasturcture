resource "aws_iam_role" "kthamel-eks-nodes-iam-role" {
  name = "kthamel-eks-nodes-iam-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "kthamel-eks-node-iam-role-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.kthamel-eks-nodes-iam-role.name
}

resource "aws_iam_role_policy_attachment" "kthamel-eks-ecr-iam-role-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.kthamel-eks-nodes-iam-role.name
}

resource "aws_iam_role_policy_attachment" "kthamel-eks-cni-iam-role-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.kthamel-eks-nodes-iam-role.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.kthamel-eks-cluster.name
  node_group_name = "worker-nodes"
  node_role_arn   = aws_iam_role.kthamel-eks-nodes-iam-role.arn

  subnet_ids = [
    aws_subnet.kthamel-eks-subnet-1.id,
    aws_subnet.kthamel-eks-subnet-2.id,
    aws_subnet.kthamel-eks-subnet-3.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.micro"]
  scaling_config {
    desired_size = 2
    min_size     = 0
    max_size     = 2
  }
  update_config {
    max_unavailable = 1
  }
  labels = {
    node_type = "workers"
  }

  tags = local.common_tags
}
