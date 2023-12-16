terraform {
  backend "s3" {
    bucket = "kthamel-cloud-automation-vault"
    key    = "demo-vpc-tfstate"
    region = "us-east-1"
  }
}