data "aws_partition" "this" {}

data "aws_region" "this" {}

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

data "aws_iam_policy_document" "allowed_s3" {
  statement {
    sid    = "AllowedSSM"
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "ssm:*",
    ]
    resources = ["arn:${data.aws_partition.this.partition}:ssm:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:parameter/azure/devops/ocp/*"] #tfsec:ignore:aws-iam-no-policy-wildcards
  }

  statement {
    sid    = "AllowedS3Access"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = [
      "arn:${data.aws_partition.this.partition}:s3:::ocp-*-${data.aws_region.this.name}-configurations",
      "arn:${data.aws_partition.this.partition}:s3:::ocp-*-${data.aws_region.this.name}-configurations/*",
      "arn:${data.aws_partition.this.partition}:s3:::ocp-*-${data.aws_region.this.name}-nlu",
      "arn:${data.aws_partition.this.partition}:s3:::ocp-*-${data.aws_region.this.name}-nlu/*",
      "arn:${data.aws_partition.this.partition}:s3:::ocp-*-${data.aws_region.this.name}-deepasr-models",
      "arn:${data.aws_partition.this.partition}:s3:::ocp-*-${data.aws_region.this.name}-deepasr-models/*"
    ]
  }
}