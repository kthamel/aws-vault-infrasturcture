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

resource "aws_secretsmanager_secret" "ec2-private-key" {
  name = "kthamel-ec2-private-key-password"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.ec2-private-key.id
  secret_string = tls_private_key.ssh_key.private_key_pem
}

resource "aws_instance" "vault-instance" {
  ami             = "ami-0759f51a90924c166"
  instance_type   = "t2.micro"
  security_groups = ["sg-0d0260003b1b9faa2"]
  subnet_id       = "subnet-04aad8bef125e3685"
  key_name        = aws_key_pair.ssh_key_pub.key_name
  connection {
    user        = "ec2-user"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = self.public_ip
  }

  tags = {
    Name    = "vault-instance"
    Project = "IAC-TF"
  }

  provisioner "local-exec" {
    command = "chmod 0400 ${local_file.private_key_pem.filename}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /tmp/*",
      "sudo echo Hello World > /tmp/kthamel-iac.txt"
    ]

  }
}

resource "aws_instance" "remote-exec-instance" {
  ami             = "ami-0759f51a90924c166"
  instance_type   = "t2.micro"
  security_groups = ["sg-0c61d454530de1772"]
  subnet_id       = "subnet-02f890ca3c0e3a022"
  key_name        = aws_key_pair.ssh_key_pub.key_name
  connection {
    user        = "ec2-user"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = self.public_ip
  }

  tags = {
    Name    = "remote-exec-instance"
    Project = "IAC-TF"
  }
}
