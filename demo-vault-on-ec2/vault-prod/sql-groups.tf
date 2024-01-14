resource "aws_db_subnet_group" "kthamel-mysql-subnet-group" {
  name       = "mysql-subnet-group"
  subnet_ids = [aws_subnet.kthamel-ec2-subnet-0.id, aws_subnet.kthamel-ec2-subnet-2.id]

  tags = local.common_tags
}

resource "aws_db_parameter_group" "kthamel-db-parameter-grp" {
  name   = "kthamel-db-parameter-grp"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  tags = local.common_tags
}
