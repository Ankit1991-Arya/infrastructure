#Allowing Nexpose Scan Engine into Shared EKS Nodes
locals {
  shared_eks_sg_id    = "sg-006d173bd26dfd92d"
  scan_engine_ip_cidr = "${data.aws_instance.scan_engine_ec2.private_ip}/32"
}

data "aws_instance" "scan_engine_ec2" {
  instance_id = module.nexpose_engine_servers.instance_id["nexpose-engine-corenetwork"]
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