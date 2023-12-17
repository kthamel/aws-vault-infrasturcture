resource "aws_eip" "kthamel-eks-elastic-ip" {
  domain = "vpc"

  tags = local.common_tags
}

resource "aws_nat_gateway" "kthamel-eks-nat-gw" {
  allocation_id = aws_eip.kthamel-eks-elastic-ip.id
  subnet_id     = aws_subnet.kthamel-eks-subnet-0.id

  depends_on = [aws_internet_gateway.kthamel-eks-igw]

  tags = local.common_tags
}