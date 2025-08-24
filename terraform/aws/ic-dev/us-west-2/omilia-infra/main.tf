resource "random_id" "id" {
  byte_length = 8
}

data "aws_vpc" "target-vpc" {
  tags = {
    Name = var.vpc_name_common
  }
}

data "aws_db_subnet_group" "subnet_group_common" {
  name = var.db_subnet_group_common
}

resource "aws_security_group" "allow_rds" {
  name        = "${local.instance_name}-allow-sg-aurora"
  description = "enable mysql/aurora access on port 3306"
  vpc_id      = data.aws_vpc.target-vpc.id
  tags        = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "vpc_instance" {
  security_group_id = aws_security_group.allow_rds.id

  description = "VPC instances"
  cidr_ipv4   = var.vpc_cidr
  from_port   = 3306
  ip_protocol = "tcp"
  to_port     = 3306
  tags        = local.common_tags

}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.allow_rds.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  tags        = local.common_tags
}



#tfsec:ignore:aws-rds-encrypt-cluster-storage-data
resource "aws_rds_cluster" "omilia-rds-cluster" {
  cluster_identifier = "${local.instance_name}-cluster-${var.environment}"

  engine                              = "aurora-mysql"
  engine_mode                         = "provisioned"
  engine_version                      = var.engine_version
  database_name                       = var.database_name
  master_username                     = local.credentials["username"]
  master_password                     = local.credentials["password"]
  iam_database_authentication_enabled = true

  db_subnet_group_name        = data.aws_db_subnet_group.subnet_group_common.name
  vpc_security_group_ids      = [aws_security_group.allow_rds.id]
  availability_zones          = ["us-west-2a", "us-west-2b", "us-west-2c"]
  backup_retention_period     = 5
  preferred_backup_window     = "07:00-09:00"
  skip_final_snapshot         = false
  final_snapshot_identifier   = "${local.instance_name}-cluster-${var.environment}-${random_id.id.hex}"
  allow_major_version_upgrade = false
  copy_tags_to_snapshot       = false
  deletion_protection         = false

  serverlessv2_scaling_configuration {
    max_capacity = var.max_acu
    min_capacity = var.min_acu
  }
  tags = local.common_tags
}
#tfsec:ignore:aws-rds-enable-performance-insights-encryption
resource "aws_rds_cluster_instance" "omilia-rds" {
  count              = var.instance_count
  identifier         = "${local.instance_name}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.omilia-rds-cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.omilia-rds-cluster.engine
  engine_version     = aws_rds_cluster.omilia-rds-cluster.engine_version

  performance_insights_enabled = true
  publicly_accessible          = false
  auto_minor_version_upgrade   = true
  tags                         = local.common_tags
}