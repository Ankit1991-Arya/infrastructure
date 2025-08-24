#
# Create or reference a CloudWatch log group.
#
data "aws_cloudwatch_log_group" "existing" {
  count = var.log_group_name == null || var.create_log_group ? 0 : 1
  name  = var.log_group_name
}

resource "aws_cloudwatch_log_group" "main" {
  count             = var.log_group_name != null && var.create_log_group ? 1 : 0
  name              = var.log_group_name
  retention_in_days = var.log_group_retention
  tags              = local.tags
}

#
# AMP Workspace.
#
resource "aws_prometheus_workspace" "main" {
  alias = var.alias
  tags  = local.tags

  dynamic "logging_configuration" {
    for_each = var.log_group_name != null ? ["once"] : []

    content {
      log_group_arn = "${var.create_log_group ? aws_cloudwatch_log_group.main[0].arn : data.aws_cloudwatch_log_group.existing[0].arn}:*"
    }
  }
}
