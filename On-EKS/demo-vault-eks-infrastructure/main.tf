locals {
  Name    = "EKS-VPC"
  Project = "DevOps-Vault"
}

locals {
  common_tags = {
    Name           = local.Name
    DevOps_Project = local.Project
  }
}
