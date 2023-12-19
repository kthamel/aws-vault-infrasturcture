terraform {
  backend "s3" {
    bucket = "kthamel-vault-eks-deployment"
    key    = "demo-vpc-tfstate"
    region = "us-east-1"
  }
}
