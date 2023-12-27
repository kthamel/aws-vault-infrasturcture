resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "ec2_ssh_key.pem"
}

resource "aws_key_pair" "ssh_key_pub" {
  key_name   = "ec2_ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}

resource "random_string" "secret-string" {
  length  = 5
  numeric = true
  lower   = true
  upper   = false
  special = false
}

resource "aws_secretsmanager_secret" "ec2-private-key" {
  name = random_string.secret-string.id
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.ec2-private-key.id
  secret_string = tls_private_key.ssh_key.private_key_pem
}

resource "aws_instance" "ssh-instance" {
  ami             = "ami-079db87dc4c10ac91"
  subnet_id       = aws_subnet.kthamel-ec2-subnet-0.id
  security_groups = [aws_security_group.public-subnet-assoc.id]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ssh_key_pub.key_name
  connection {
    user        = "ec2-user"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = self.public_ip
  }

  tags = local.common_tags
}

resource "aws_instance" "vault-instance" {
  ami             = "ami-079db87dc4c10ac91"
  subnet_id       = aws_subnet.kthamel-ec2-subnet-1.id
  security_groups = [aws_security_group.private-subnet-assoc.id]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ssh_key_pub.key_name
  user_data       = <<-EOF
#!/bin/bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install vault  
EOF
  connection {
    user        = "ec2-user"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = self.private_ip
  }

  tags = local.common_tags
}
