resource "aws_internet_gateway" "kthamel-eks-igw" {
  vpc_id = aws_vpc.kthamel-eks-vpc.id

  tags = local.common_tags
}
