locals {
  lb_name = "Nexpose-Console-NLB"
}

// Create a private NLB that will target the private ALB
resource "aws_lb" "nexpose_private_nlb" {
  name                       = local.lb_name
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = local.sectools_private_subnets
  enable_deletion_protection = true
  security_groups            = [module.nlb_aws_security_group["nexpose-security-console"].sg_id]

  tags = {
    "traffic-type" = "private"
  }
  depends_on = [module.nlb_aws_security_group]
}

# Create NLB target group that forwards traffic to alb
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
resource "aws_lb_target_group" "nlb_console_tg" {
  name        = "Nexpose-UI-TG"
  port        = 3780
  protocol    = "TCP"
  vpc_id      = local.sectools_vpc_id
  target_type = "instance"

  health_check {
    // Must use HTTPS since the ALB is only listening on port 443
    // In order for this to work a rule must be added into the
    // alb target to successfully route requests with the following
    // data:
    //   HTTP Method: GET
    //   HTTP Path: /
    //   Request Headers:
    //     user-agent: ELB-HealthChecker/2.0
    protocol = "TCP"
  }
}

# Create target group attachment
# More details: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TargetDescription.html
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RegisterTargets.html
resource "aws_lb_target_group_attachment" "nlb_console_tg_attachment" {
  target_group_arn = aws_lb_target_group.nlb_console_tg.arn
  # target to attach to this target group
  target_id = module.nexpose_servers.instance_id["nexpose-security-console"]
  #  If the target type is alb, the targeted Application Load Balancer must have at least one listener whose port matches the target group port.
  port       = 3780
  depends_on = [module.nexpose_servers]
}

# Create a listener to attach the target group to the NLB. The NLB will forward all traffic to the ALB
# so it is not desired that SSL termintation occur at the NLB.
resource "aws_lb_listener" "private_console_nlb" {
  load_balancer_arn = aws_lb.nexpose_private_nlb.arn
  port              = "3780"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_console_tg.arn
  }
}

# Create NLB target group that forwards traffic to alb
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
resource "aws_lb_target_group" "nlb_scanengine_tg" {
  name        = "Nexpose-ScanEngine-TG"
  port        = 40815
  protocol    = "TCP"
  vpc_id      = local.sectools_vpc_id
  target_type = "instance"

  health_check {
    // Must use HTTPS since the ALB is only listening on port 443
    // In order for this to work a rule must be added into the
    // alb target to successfully route requests with the following
    // data:
    //   HTTP Method: GET
    //   HTTP Path: /
    //   Request Headers:
    //     user-agent: ELB-HealthChecker/2.0
    protocol = "TCP"
  }
}

# Create target group attachment
# More details: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TargetDescription.html
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RegisterTargets.html
resource "aws_lb_target_group_attachment" "nlb_scanengine_tg_attachment" {
  target_group_arn = aws_lb_target_group.nlb_scanengine_tg.arn
  # target to attach to this target group
  target_id = module.nexpose_servers.instance_id["nexpose-security-console"]
  #  If the target type is alb, the targeted Application Load Balancer must have at least one listener whose port matches the target group port.
  port       = 40815
  depends_on = [module.nexpose_servers]
}

# Create a listener to attach the target group to the NLB. The NLB will forward all traffic to the ALB
# so it is not desired that SSL termintation occur at the NLB.
resource "aws_lb_listener" "private_scanengine_nlb" {
  load_balancer_arn = aws_lb.nexpose_private_nlb.arn
  port              = "40815"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_scanengine_tg.arn
  }
}

module "nlb_aws_security_group" { # used for vpc_security_group_ids, need to set output to sg_id in security_groups module to use here
  source                               = "spacelift.io/incontact/aws_security_groups/default"
  version                              = "0.1.0"
  for_each                             = { for key, value in local.ec2_instances_data.ec2_instances_data : key => value if value.create_new_nlb_security_group == true }
  name                                 = each.value.nexpose_nlb_sg_name
  vpc_id                               = local.sectools_vpc_id
  aws_vpc_security_group_ingress_rules = try(each.value.aws_vpc_security_group_ingress_rules, {})
  aws_vpc_security_group_egress_rules  = try(each.value.aws_vpc_security_group_egress_rules, {})
  tags                                 = each.value.tags
}