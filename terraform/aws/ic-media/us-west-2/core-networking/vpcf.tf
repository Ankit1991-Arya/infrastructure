resource "aws_vpc" "media-services" {
  cidr_block = "10.0.0.0/16"
  # assign_generated_ipv6_cidr_block = true
  instance_tenancy = "default"

  tags = {
    Name  = "Terraform Sandbox"
    Owner = "MediaServices"
  }
}

resource "aws_flow_log" "media-services" {
  depends_on = [aws_vpc.media-services]
  # iam_role_arn = "GroupAccess-Developers-Mediaservices"
  # log_destination = aws_cloudwatch_log_group.example.arn
  traffic_type = "ALL"
  vpc_id       = aws_vpc.media-services.id
}
