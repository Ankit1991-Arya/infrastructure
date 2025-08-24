resource "aws_ssm_parameter" "dns_ssm" {
  for_each = local.records
  name     = "/euft/${each.key}-shared-eks-dns"
  type     = "String"
  value    = each.value.a_record_name
}