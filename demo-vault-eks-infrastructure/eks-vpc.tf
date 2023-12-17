resource "aws_vpc" "kthamel-eks-vpc" {
  cidr_block                       = "172.32.0.0/16"
  assign_generated_ipv6_cidr_block = false

  tags = local.common_tags
}
