data "aws_partition" "this" {}

data "aws_iam_policy_document" "allowed_ecr" {
  statement {
    sid    = "AllowedAWSECR"
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "ecr:*", # Amazon Elastic Container Registry
    ]
    resources = ["*"] #tfsec:ignore:aws-iam-no-policy-wildcards
  }

  statement {
    sid    = "AllowedSecretManager"
    effect = "Allow"

    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:GetSecretValue"
    ]
    resources = ["arn:${data.aws_partition.this.partition}:secretsmanager:*:*:secret:omilia*"]
  }
}