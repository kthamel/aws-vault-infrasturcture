terraform {
  backend "s3" {
    bucket = "kthamel-vault-automation-ec2"
    key    = "demo-vpc-tfstate"
    region = "us-east-1"
  }
}
