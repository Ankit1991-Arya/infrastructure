#Allowing Nexpose Scan Engine into Shared EKS Nodes
locals {
  shared_eks_sg_id    = "sg-0a82fedc0e67f585e"
  scan_engine_ip_cidr = "10.232.152.0/24"
}

data "aws_security_group" "shared_eks_node_sg" {
  id = local.shared_eks_sg_id
}

resource "aws_security_group_rule" "allow_scan_engine" {
  type              = "ingress"
  from_port         = 21047
  to_port           = 21047
  protocol          = "tcp"
  cidr_blocks       = [local.scan_engine_ip_cidr]
  security_group_id = data.aws_security_group.shared_eks_node_sg.id
}