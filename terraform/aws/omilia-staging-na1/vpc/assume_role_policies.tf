data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    principals {
      identifiers = ["cloudformation.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
  statement {
    principals {
      identifiers = ["arn:${data.aws_partition.this.partition}:iam::${data.aws_caller_identity.this.account_id}:oidc-provider/token.actions.githubusercontent.com"]
      type        = "Federated"
    }
    condition {
      test     = "StringLike"
      values   = ["repo:inContact/omilia-terraform-modules:*"]
      variable = "token.actions.githubusercontent.com:sub"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    sid     = "Github"
  }
}