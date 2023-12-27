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

  provisioner "local-exec" {
    command = "chmod 0400 ${local_file.private_key_pem.filename}"
  }

  provisioner "file" {
    source      = "ec2_ssh_key.pem"
    destination = "/home/ec2-user/ec2_ssh_key.pem"
  }

  tags = local.common_tags
}

resource "aws_instance" "vault-instance" {
  ami             = "ami-079db87dc4c10ac91"
  subnet_id       = aws_subnet.kthamel-ec2-subnet-1.id
  security_groups = [aws_security_group.private-subnet-assoc.id]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ssh_key_pub.key_name

  user_data = <<-EOF
#!/bin/bash
## Install HashiCorp Vault ##
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

output "ssh-instance-eip" {
  description = "Public IP of SSH Instance"
  value       = aws_instance.ssh-instance.public_ip
}

output "vault-instance-ip" {
  description = "Private IP of Vault Instance"
  value       = aws_instance.vault-instance.private_ip
}
