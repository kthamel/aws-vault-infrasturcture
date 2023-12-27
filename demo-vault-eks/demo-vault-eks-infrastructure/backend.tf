terraform {
  backend "s3" {
    bucket = "kthamel-vault-automation-eks"
    key    = "demo-vpc-tfstate"
    region = "us-east-1"
  }
}
