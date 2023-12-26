resource "aws_subnet" "kthamel-eks-subnet-0" {
  vpc_id                  = aws_vpc.kthamel-eks-vpc.id
  cidr_block              = "172.32.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = local.common_tags
}

resource "aws_subnet" "kthamel-eks-subnet-1" {
  vpc_id            = aws_vpc.kthamel-eks-vpc.id
  cidr_block        = "172.32.1.0/24"
  availability_zone = "us-east-1a"

  tags = local.common_tags
}

resource "aws_subnet" "kthamel-eks-subnet-2" {
  vpc_id            = aws_vpc.kthamel-eks-vpc.id
  cidr_block        = "172.32.2.0/24"
  availability_zone = "us-east-1b"

  tags = local.common_tags
}

resource "aws_subnet" "kthamel-eks-subnet-3" {
  vpc_id            = aws_vpc.kthamel-eks-vpc.id
  cidr_block        = "172.32.3.0/24"
  availability_zone = "us-east-1c"

  tags = local.common_tags
}
