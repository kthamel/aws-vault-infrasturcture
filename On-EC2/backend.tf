terraform {
  backend "s3" {
    bucket = "kthamel-vault-ec2-deployment"
    key    = "demo-vpc-tfstate"
    region = "us-east-1"
  }
}
