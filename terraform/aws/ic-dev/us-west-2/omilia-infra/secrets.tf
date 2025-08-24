resource "aws_secretsmanager_secret" "omilia-db-user" {
  name        = "AuroraDB-Omilia-DB"
  description = "API User to access auroradb"
  tags        = local.common_tags
}

resource "random_password" "omilia-db-password" {
  length      = 16
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
}

resource "aws_secretsmanager_secret_version" "omilia-db-user" {
  secret_id = aws_secretsmanager_secret.omilia-db-user.id
  secret_string = jsonencode({
    "username" : var.username,
    "password" : random_password.omilia-db-password.result
  })
}