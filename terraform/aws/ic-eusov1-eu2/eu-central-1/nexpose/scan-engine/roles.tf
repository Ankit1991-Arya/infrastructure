data "aws_partition" "this" {}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid    = "S3SessionEncryptionAccess"
    effect = "Allow"
    actions = [
      "s3:GetEncryptionConfiguration"
    ]
    resources = [
      "arn:aws:s3:::ic-sessionmanager-auditlogs-*"
    ]
  }
}

module "nexpose_ec2_instance_profile_role" {
  source             = "github.com/inContact/acddevops-terraform-modules-iam.git//modules/service-role?ref=v7.12.0"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2_ssm.json
  description        = "The role that will be used by Nexpose ec2 instances for SSM Access"
  name_noprefix      = "nexpose-ec2-ssm-instance-profile-role"
  policy_arns        = ["arn:${data.aws_partition.this.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  policy_documents_json = {
    "one" = data.aws_iam_policy_document.s3_bucket_policy.json
  }
}