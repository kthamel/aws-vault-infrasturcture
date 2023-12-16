resource "aws_vpc" "iac-terraform" {
  instance_tenancy = "default"
  cidr_block       = "172.32.0.0/16"

  tags = {
    Name = "IAC-Terraform"
  }
}
