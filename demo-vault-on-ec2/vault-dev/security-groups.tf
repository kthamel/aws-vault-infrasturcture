resource "aws_security_group" "public-subnet-assoc" {
  name = "public-subnet-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.kthamel-ec2-vpc.id

  tags = local.common_tags
}

resource "aws_security_group" "private-subnet-assoc" {
  name = "private-subnet-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.32.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.kthamel-ec2-vpc.id

  tags = local.common_tags
}
