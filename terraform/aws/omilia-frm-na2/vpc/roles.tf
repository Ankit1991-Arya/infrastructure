module "service_role_omila_aws_ecr_sync" {
  source             = "github.com/inContact/acddevops-terraform-modules-iam.git//modules/service-role?ref=v7.12.0"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  description        = "The role that will be used by Omilia for Github ecr sync"
  name_noprefix      = "omilia-ecr-sync"
  policy_documents_json = {
    "one" = data.aws_iam_policy_document.allowed_ecr.json
  }
}