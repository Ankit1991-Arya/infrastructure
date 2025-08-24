locals {
  lb_name = "Logscale-UI-NLB"
}

// Create a private NLB that will target the private ALB
resource "aws_lb" "logscale_private_nlb" {
  name                       = local.lb_name
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = local.sectools_private_subnets
  enable_deletion_protection = true
  security_groups            = [module.nlb_aws_security_group["logscale"].sg_id]

  tags = {
    "traffic-type" = "private"
  }
  depends_on = [module.nlb_aws_security_group]
}

data "aws_lb" "sectools-ingress-alb" {
  name = var.sectools-ingress-alb
}

# Create NLB target group that forwards traffic to alb
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
resource "aws_lb_target_group" "nlb_console_tg" {
  name        = "Logscale-UI-TG"
  port        = 443
  protocol    = "TCP"
  vpc_id      = local.sectools_vpc_id
  target_type = "alb"

  health_check {
    // Must use HTTPS since the ALB is only listening on port 443
    // In order for this to work a rule must be added into the
    // alb target to successfully route requests with the following
    // data:
    //   HTTP Method: GET
    //   HTTP Path: /
    //   Request Headers:
    //     user-agent: ELB-HealthChecker/2.0
    protocol = "HTTPS"
  }
}

# Create target group attachment
# More details: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TargetDescription.html
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RegisterTargets.html
resource "aws_lb_target_group_attachment" "nlb_console_tg_attachment" {
  target_group_arn = aws_lb_target_group.nlb_console_tg.arn
  # target to attach to this target group
  target_id = data.aws_lb.sectools-ingress-alb.arn
  #  If the target type is alb, the targeted Application Load Balancer must have at least one listener whose port matches the target group port.
  port = 443
}

# Create a listener to attach the target group to the NLB. The NLB will forward all traffic to the ALB
# so it is not desired that SSL termintation occur at the NLB.
resource "aws_lb_listener" "private_console_nlb" {
  load_balancer_arn = aws_lb.logscale_private_nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_console_tg.arn
  }
}

module "nlb_aws_security_group" { # used for vpc_security_group_ids, need to set output to sg_id in security_groups module to use here
  source                               = "spacelift.io/incontact/aws_security_groups/default"
  version                              = "0.1.0"
  for_each                             = { for key, value in local.logscale_sg_data.logscale-sg-config : key => value if value.create_new_nlb_security_group == true }
  name                                 = each.value.logscale_nlb_sg_name
  vpc_id                               = local.sectools_vpc_id
  aws_vpc_security_group_ingress_rules = try(each.value.aws_vpc_security_group_ingress_rules, {})
  aws_vpc_security_group_egress_rules  = try(each.value.aws_vpc_security_group_egress_rules, {})
  tags                                 = each.value.tags
}