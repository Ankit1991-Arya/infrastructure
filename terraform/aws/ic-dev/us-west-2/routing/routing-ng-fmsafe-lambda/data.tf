data "aws_kinesis_stream" "stream" {
  name = var.kinesis_stream
}

data "aws_db_subnet_group" "routing-ng-subnet" {
  name = var.rds_subnetgroup
}

data "aws_security_group" "rds_sg" {
  id = var.afm_sg
}