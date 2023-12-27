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

resource "aws_network_interface" "vault-instance-nic" {
  subnet_id       = aws_subnet.kthamel-ec2-subnet-1.id
  private_ips     = ["172.32.1.100"]
  security_groups = [aws_security_group.private-subnet-assoc.id]

  attachment {
    instance     = aws_instance.vault-instance.id
    device_index = 1
  }
}

resource "aws_instance" "vault-instance" {
  ami             = "ami-079db87dc4c10ac91"
  subnet_id       = aws_subnet.kthamel-ec2-subnet-1.id
  security_groups = [aws_security_group.private-subnet-assoc.id]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ssh_key_pub.key_name
  depends_on      = [aws_ebs_volume.vault-storage-backend]

  user_data = <<-EOF
#!/bin/bash
## Install dependencies ##
sudo yum install git -y
## Clone the vault configurations ##
sudo git clone https://github.com/kthamel/aws-vault-hcl-configuration.git
## Setup vault prod server ## 
sudo bash aws-vault-hcl-configuration/script.sh

EOF

  connection {
    user        = "ec2-user"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = self.private_ip
  }

  tags = local.common_tags
}

resource "aws_ebs_volume" "vault-storage-backend" {
  availability_zone = "us-east-1a"
  size              = 2
  type              = "gp2"

  tags = local.common_tags
}

resource "aws_volume_attachment" "vault-storage-backend" {
  device_name = "/dev/xvdk"
  volume_id   = aws_ebs_volume.vault-storage-backend.id
  instance_id = aws_instance.vault-instance.id
}

output "ssh-instance-eip" {
  description = "Public IP of SSH Instance"
  value       = aws_instance.ssh-instance.public_ip
}
