output "workspace_id" {
  value = aws_prometheus_workspace.main.id
}

output "workspace_arn" {
  value = aws_prometheus_workspace.main.arn
}

output "workspace_alias" {
  value = aws_prometheus_workspace.main.alias
}

output "prometheus_endpoint" {
  value = aws_prometheus_workspace.main.prometheus_endpoint
}
