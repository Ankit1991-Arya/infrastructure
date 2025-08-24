module "service_role_github" {
  # This role will be used to trigger jobs in GitHub Actions, i.e. Packer
  source             = "github.com/inContact/acddevops-terraform-modules-iam.git//modules/service-role?ref=v7.3.0"
  name               = "github"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_github.json
  description        = "A role for GitHub Actions jobs related to Nexpose."

  policy_documents_json = {
    "packer" = data.aws_iam_policy_document.packer.json
  }
}

module "nexpose_ec2_instance_profile_role" {
  source             = "github.com/inContact/acddevops-terraform-modules-iam.git//modules/service-role?ref=v7.12.0"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2_ssm.json
  description        = "The role that will be used by Nexpose ec2 instances for SSM Access"
  name_noprefix      = "nexpose-ec2-ssm-instance-profile-role"
  policy_arns        = ["arn:${data.aws_partition.this.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}