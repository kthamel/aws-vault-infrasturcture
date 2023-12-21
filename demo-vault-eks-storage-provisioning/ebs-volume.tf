resource "aws_ebs_volume" "vault-storage" {
  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp3"

  tags = {
    Name = "Vault_Storage_backend"
  }
}

output "vault-ebs-volume-id" {
  value = aws_ebs_volume.vault-storage.id
}
