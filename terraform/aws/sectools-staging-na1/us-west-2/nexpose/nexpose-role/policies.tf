#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "packer" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeyPair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteKeypair",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeregisterImage",
      "ec2:ModifyImageAttribute"
    ]
    resources = [
      "arn:${data.aws_partition.this.partition}:secretsmanager:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:secret:nexpose/*",
      "arn:${data.aws_partition.this.partition}:ec2:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:instance/*",
      "arn:${data.aws_partition.this.partition}:ec2:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:key-pair/packer_*",
      "arn:${data.aws_partition.this.partition}:ec2:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:network-interface/*",
      "arn:${data.aws_partition.this.partition}:ec2:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:security-group/*",
      "arn:${data.aws_partition.this.partition}:ec2:${data.aws_region.this.name}::image/*",
      "arn:${data.aws_partition.this.partition}:ec2:${data.aws_region.this.name}::snapshot/*",
      "arn:${data.aws_partition.this.partition}:ec2:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:vpc/*",
    ]
  }

  statement {
    sid    = "Rapid7"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::nexpose-hardening/rapid7/*"]
  }

  statement {
    sid    = "Unbound"
    effect = "Allow"
    actions = [
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances"
    ]
    resources = ["*"]
  }
}