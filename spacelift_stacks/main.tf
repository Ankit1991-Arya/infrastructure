locals {
  excluded_paths_regex  = "terraform/spacelift/stacks/\\.terraform/.*"
  root_path             = "${path.module}/../${local.terraform_folder_name}"
  terraform_folder_name = "terraform"
}

output "stacks" {
  description = "A map of stack configurations where the key is the relative path to the stack project directory from the root of this repository and the value contains the contents of spacelift.yaml in the stack project directory."
  value = {
    for s in fileset(local.root_path, "**/spacelift.yaml") :
    "${local.terraform_folder_name}/${replace(s, "/spacelift.yaml", "")}" => yamldecode(file("${local.root_path}/${s}"))
    if length(regexall(local.excluded_paths_regex, "${local.terraform_folder_name}/${s}")) == 0 # need to filter out the external modules that are downloaded by terraform/spacelift/stacks or else the spacelift.yaml files in the external repositories will be discovered
  }
}
