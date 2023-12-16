resource "aws_subnet" "iac-terraform-private-subnet" {
  vpc_id     = aws_vpc.iac-terraform.id
  cidr_block = "172.32.0.0/24"

  tags = {
    Name = "iac-terraform-private-subnet"
  }
}

resource "aws_subnet" "iac-terraform-public-subnet" {
  vpc_id                  = aws_vpc.iac-terraform.id
  cidr_block              = "172.32.10.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "iac-terraform-public-subnet"
  }
}

resource "aws_internet_gateway" "iac-terraform-igw" {
  vpc_id = aws_vpc.iac-terraform.id

  tags = {
    Name = "iac-terraform-igw"
  }
}

resource "aws_route_table" "iac-terraform-routing-table" {
  vpc_id = aws_vpc.iac-terraform.id

  route {
    cidr_block = "172.32.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac-terraform-igw.id
  }

  tags = {
    Name = "iac-terraform-routing-table"
  }
}

resource "aws_security_group" "iac-terraform-public-sg" {
  name   = "iac-terraform-public-sg"
  vpc_id = aws_vpc.iac-terraform.id
  ingress {
    description = "Inbound"
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

  tags = {
    Name = "Allow_TLS"
  }
}

resource "aws_security_group" "iac-terraform-vault-sg" {
  name   = "iac-terraform-vault-sg"
  vpc_id = aws_vpc.iac-terraform.id
  ingress {
    description = "Inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.iac-terraform-public-subnet.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_TLS"
  }
}
