resource "aws_lb" "uptime-nlb" {
  name               = "uptime-service-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.subnets_id]
  enable_cross_zone_load_balancing = false
}

resource "aws_lb_target_group" "nlb-target-group" {
  name     = "uptime-service-target-group"
  port     = var.nlb_config.data.nlb.port
  protocol = var.nlb_config.data.nlb.protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.uptime-nlb.arn
  port              = var.nlb_config.data.nlb.port
  protocol          = var.nlb_config.data.nlb.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-target-group.arn
  }
}

output "nlb_arn_output" {
  value       = aws_lb.uptime-nlb.arn
}