# Okta
Terraform for our different Okta tenants to define Okta groups and the applications that should be assigned to those groups.

[This](https://niceonline-my.sharepoint.com/:v:/g/personal/ruth_brown_niceincontact_com/EcCNe1fVoqVIgBKzS56mhEQBtp8HB8I5QmgziVKWFAfehw?e=8aYbdR) recording gives a walk through of how much of the code in this directory works.

## What is defined in each Okta tenant?

For each tenant you will see an applications module and a groups module. The source for these modules is defined in the [terraform-okta-config repository](https://github.com/inContact/terraform-okta-config).

### Applications module
The purpose of the applications module is to add the Okta IDP (identity provider) to the different AWS accounts we want to trust this Okta tenant. For each AWS account we want to trust this Okta tenant, there will be an `aws` provider and a `aws_iam_saml_provider` resource defined in the module.

```
provider "aws" {
  alias = "ic_dev"
  assume_role {
    role_arn = "arn:aws:iam::300813158921:role/ServiceAccess-infrastructure-live-terraform"
  }
  region = "us-west-2"
}

resource "aws_iam_saml_provider" "okta_ic_dev" {
  provider               = aws.ic_dev
  name                   = local.aws_saml_identity_provider_name
  saml_metadata_document = module.aws-saml-application.okta_app_saml_metadata
  tags = {
    InfrastructureOwner = "Systems Teams"
    Product             = "okta"
  }
}
```

Within the `aws` provider, an `assume_role` needs to be listed with appropriate permissions as this will be the role used by the pipeline to deploy the IDP. The role deployed and used in all currently implemented accounts is defined [here](https://github.com/inContact/cicd-iam-service-roles/blob/3d495b345223138e0a97e4d2681a6698d2f855af/infrastructure-live/roles.tf#L10).

### Groups module
The purpose of the groups module is to define the different groups we want to create in Okta and assign Okta applications to those groups. The first thing we want to pay attention to when defining the `dept_groups` module is the different `app_label` variables:

* `app_label_aws` - The label(s) applied to the AWS application(s) in the current Okta tenant. All matching applications will be attached to provisioned department groups if the aws attribute is set to `true`.
* `app_label_azure` - The label(s) applied to the Azure application(s) in the current Okta tenant. All matching applications will be attached to provisioned department groups if the azure attribute is set to `true`.
* `app_label_gcp` - The label(s) applied to the GCP application(s) in the current Okta tenant. All matching applications will be attached to provisioned department groups if the gcp attribute is set to `true`.
* `app_label_okta_org2org` - The label applied to the Okta Org2Org application in the current Okta tenant. Declare `null` in okta tenants that do not have an Org2Org application. If a value is declared then the matching application will be attached to all provisioned department groups.

After the applications are defined, next we can start defining the different department groups, let's break down the example below defining the CloudNativeCore department and rules:

```
app_label_aws          = ["AWS-Standard", "AWS-FRM"]
app_label_azure        = ["Azure-Standard"]
app_label_gcp          = []
app_label_okta_org2org = "DirSync_Okta-FRM_to_Okta-Std"
dept_groups = {
  CloudNativeCore = {
    aws = true
    aws_role_okta_groups = {
      ic-compliance-prod = ["GroupAccess-CNC"]
    }
    azure = true
    gcp   = false
  }
}
```

A few things will be created with this code:
1. An Okta group Dept_CloudNativeCore, this group will be assigned all applications listed under `app_label_aws` and `app_label_azure` since the `aws` and `azure` booleans are true. Additionally this group will be assigned the `app_label_okta_org2org` app since that value is not null.
2. For each `aws_role_okta_groups`, an Okta group will also be created
    1. For this example, a group will be created named aws#ic-compliance-prod#GroupAccess-CNC#751344753113. This name is built up using terraform [here](https://github.com/inContact/terraform-okta-config/blob/bfae342ec29900909f62af26c2948ec60b2ac7ac/modules/dept-groups/main.tf#L29) and is only compatible with AWS accounts in [this array](https://github.com/inContact/terraform-okta-config/blob/bfae342ec29900909f62af26c2948ec60b2ac7ac/modules/dept-groups/locals.tf#L4).
    2. This aws#ic-compliance-prod#GroupAccess-CNC#751344753113 group will be needed by its members when logging into the ic-compliance-prod AWS account through the corresponding AWS Okta application. It is directing the app to use the GroupAccess-CNC role when logging the user into ic-compliance-prod. For this to work the GroupAccess-CNC role in ic-compliance-prod also needs to grant `sts:AssumeRoleWithSAML` access to the Okta tenant that is trying to use it, in this case that can be seen [here](https://github.com/inContact/admin-iam-entities/blob/master/ic-compliance-prod/templates/ic-compliance-prod-roles.yaml#L190-L198).
3. An Okta group rule that states if user.department == "CloudNativeCore", then assign them to the groups Dept_CloudNativeCore and aws#ic-compliance-prod#GroupAccess-CNC#751344753113. This allows all users with the CloudNativeCore department on their Okta profile to be able to access the apps assigned to Dept_CloudNativeCore, and also defines that when they log into the ic-compliance-prod AWS account it will be with the GroupAccess-CNC role.

## Tenant Breakdown

### nicecxone-gov
* `aws_saml_identity_provider_name` = okta_nicecxone-gov.okta.com
* AWS Accounts supported:
    * ic-compliance-prod
    * wfocomplianceprod

### nicecxone
* `aws_saml_identity_provider_name` = okta_nicecxone.okta.com
* AWS Accounts supported:
    * nice-devops-sandbox
    * nice-devops
    * ic-dev
    * ic-test
    * ic-staging
    * ic-prod
    * wfodev
    * wfostaging
    * wfoprod

### nicecxone-gov-preview
* `aws_saml_identity_provider_name` = okta_nicecxone-gov.oktapreview.com
* AWS Accounts supported:
    * ic-dev

### nicecxone-preview
* `aws_saml_identity_provider_name` = okta_nicecxone.oktapreview.com
* AWS Accounts supported:
    * ic-ops
