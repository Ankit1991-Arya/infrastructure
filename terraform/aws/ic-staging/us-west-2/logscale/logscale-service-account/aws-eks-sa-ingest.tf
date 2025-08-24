module "ingest-role-actor" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.39.1"

  create_role       = true
  role_name_prefix  = "${var.namespace}_actor"
  role_requires_mfa = false

  custom_role_policy_arns = [
    module.iam_iam-policy-s3log.arn
  ]

  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.aws_iam_policy_document.custom_trust_policy.json

}


data "aws_iam_policy_document" "custom_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringLike"
      variable = "sts:ExternalId"
      values   = ["SINGLE_ORGANIZATION_ID/*"]
    }

    principals {
      type        = "AWS"
      identifiers = [var.cross_account_ingest_role]
    }
  }
}
module "iam_iam-assume_ingest-actor" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.39.1"

  name_prefix = "${var.namespace}-assume-ingest-base"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "FullAccess",
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Resource" : [
          module.ingest-role-actor.iam_role_arn
        ]
      },
    ]
  })
}


module "iam_iam-policy-s3log" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.39.1"

  name_prefix = "${var.namespace}-ingest-s3"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "FullAccess",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "${var.ls_cloudtrail_arn}/*",
          "${var.ls_guardduty_arn}/*"
        ]
      },
      {
        "Sid" : "ListBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          var.ls_cloudtrail_arn,
          var.ls_guardduty_arn
        ]
      }
    ]
  })
}