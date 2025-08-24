module "iam_users_975050239252" {
  source = "github.com/inContact/terraform-aws-security.git//modules/iam-users?ref=v0.68.2"

  users = {
    (local.terraform_service_user_name) = {
      json_policies = {
        s3_access = data.aws_iam_policy_document.allowed_s3_access.json
      }
    }
  }
}

resource "aws_iam_access_key" "terraform_service_user_975050239252" {
  user       = local.terraform_service_user_name
  depends_on = [module.iam_users_975050239252]
}

resource "aws_secretsmanager_secret" "programmatic_access" {
  name = local.terraform_service_user_name
}

resource "aws_secretsmanager_secret_version" "programmatic_access" {
  secret_id = local.terraform_service_user_name
  secret_string = jsonencode({
    accessKey = aws_iam_access_key.terraform_service_user_975050239252.id
    secretKey = aws_iam_access_key.terraform_service_user_975050239252.secret
  })
}

locals {
  # declaring the role names here allows for the role name to be referenced in multiple places without waiting for the
  # service-role module to run to completion. This helps to avoid circular dependencies between multiple service-role
  # modules.
  terraform_service_user_name = "_ServiceAccess-${local.role_name_terraform}"
  role_name_terraform         = "alert-logic"
}