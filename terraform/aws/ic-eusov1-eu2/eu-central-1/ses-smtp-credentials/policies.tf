# tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "smtp_send_email" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendRawEmail",
    ]
    resources = [
      "*",
    ]
  }
}