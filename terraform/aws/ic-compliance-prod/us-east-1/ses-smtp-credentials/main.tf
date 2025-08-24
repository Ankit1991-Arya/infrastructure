module "ses-smtp-credentials" {
  for_each                   = { for user in local.users : user => user }
  source                     = "spacelift.io/incontact/ses-smtp-credentials/default"
  version                    = "0.1.2"
  smtp_username              = "${each.key}-${data.aws_cloudformation_export.system_id.value}-${data.aws_cloudformation_export.area_id.value}"
  smtp_send_email_policy_arn = aws_iam_policy.ses-smtp-credentials-policy.arn
}

resource "aws_iam_policy" "ses-smtp-credentials-policy" {
  name        = "ses-smtp-credentials-policy"
  description = "A policy for ses-smtp-credentials-policy with sendEmail permission"
  policy      = data.aws_iam_policy_document.smtp_send_email.json
}

data "aws_cloudformation_export" "area_id" {
  name = "RegionConfig-AreaID"
}

data "aws_cloudformation_export" "system_id" {
  name = "RegionConfig-SystemID"
}