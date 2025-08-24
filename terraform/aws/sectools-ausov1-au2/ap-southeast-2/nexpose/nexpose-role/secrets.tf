resource "aws_secretsmanager_secret" "nexpose_logon_password" {
  name = "/nexpose/logon/password"
}

resource "aws_secretsmanager_secret_version" "nexpose_logon_password" {
  depends_on = [aws_secretsmanager_secret.nexpose_logon_password]
  secret_id  = "/nexpose/logon/password"
  secret_string = jsonencode({
    NEXPOSE_LOGON_PASSWORD = random_password.password.result
  })
}

resource "random_password" "password" {
  length           = 32
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}