# infrastructure-live

This repository contains code to define live infrastructure across various clouds and various environments.

All infrastructure code defined within this repository is deployed by [Spacelift](https://incontact.app.spacelift.io/).

If you would like help working with this repository reach out to the Cloud Native Core team using one of the following methods:

* For hands-on help submit a ticket including as much detail and requirements as possible: https://tinyurl.com/cnc-ticket
* For quick questions: https://tinyurl.com/cn-devops-questions
* For new stack: Run this workflow - https://github.com/inContact/infrastructure-live/actions/workflows/new_stack_automation.yaml. 
  Here is the more details - [Create an Empty Stack for the first time](#create-an-empty-stack-for-the-first-time)

# Repository Structure

This repository contains infrastructure as code to deploy to a variety of regions/locations within various accounts/tenants
within various cloud providers. To keep the code clean and easy to understand we organize the code according to the
following structure:

```markdown
└── {tool name} (cloudformation, terraform, etc)
    └── {Cloud Provider Name}
        └── {Account/Tenant Name}
            └── {Location/Region Name (Optional, some Cloud Providers don't have a region concept)}
                └── {Stack Name}
                    └── main.tf
```

For example, this is what the structure would look like if we use terraform with 2 cloud providers (azure and okta). This example has:

* 2 azure subscriptions with 1 location in each subscription and 3 stacks within that single location.
* 2 okta tenants with 2 stacks in each tenant. There is no location/region construct in the okta cloud provider.

```markdown
└── terraform
    ├── azure
    │   ├── azu-ic-cogs-cxone-prod
    │   │   └── southcentralus
    │   │       ├── network
    │   │       │   └── main.tf
    │   │       ├── region-config
    │   │       │   └── main.tf
    │   │       └── resource-group-builder
    │   │           └── main.tf
    │   └── azu-ic-rnd-cogs-cxone-test
    │       └── southcentralus
    │           ├── network
    │           │   └── main.tf
    │           ├── region-config
    │           │   └── main.tf
    │           └── resource-group-builder
    │               └── main.tf
    └── okta
        ├── nicecxone
        │   ├── applications
        │   │   └── main.tf
        │   └── groups
        │       └── main.tf
        └── nicecxone-preview
            ├── applications
            │   └── main.tf
            └── groups
                └── main.tf
```

# Terraform State Backend

We store terraform state for all stacks in this repository in the built-in state backend in [Spacelift](https://spacelift.io/).
For more information about this see [here](https://docs.spacelift.io/vendors/terraform/state-management).

# Contributing

This section describes the workflow which should be followed when contributing to this repository.

There is 1 stack configured in [Spacelift](https://incontact.app.spacelift.io/) per each sub-directory within the
[terraform](./terraform) directory. These stacks are configured to automatically run `terraform plan` whenever a PR is
opened to modify the stack configuration in this repo or `terraform apply` after the PR has been merged into the `main`
branch in this repo. 

When writing terraform code in this repository you should follow the following workflow:

1. Create a new branch in this repository (make sure that your new branch is up-to-date with the `main` branch in this repo)
2. Commit your changes into your new branch and push your branch to GitHub
3. [Open a Pull Request](https://github.com/inContact/infrastructure-live/compare)
4. Review the `Checks` tab on your open PR. There will be a check named `spacelift.io` wherein you can view the
  output from `terraform plan` for your changes. The `terraform plan` output will also be posted as a comment to your PR.
5. If the `terraform plan` output looks acceptable and ran successfully then you can merge your PR to the `main` branch. Once the
  change has been merged a `terraform apply` will be automatically triggered for your stack in [Spacelift](https://incontact.app.spacelift.io/).

## Creating a New Stack

Each sub-directory within the [terraform](./terraform) directory represents a unique stack in [Spacelift](https://incontact.app.spacelift.io/).
When creating a new sub-directory in the [terraform](./terraform) directory you must create a `spacelift.yaml` file in the
directory to cause a stack to be provisioned for the directory in [Spacelift](https://incontact.app.spacelift.io/). This
`spacelift.yaml` file should be in the same directory as your `main.tf` file and other `.tf` files.

The contents of the `spacelift.yaml` file can override default properties which will be set on the stack. The available
overrides are described in the [repository_stacks](https://github.com/inContact/terraform-spacelift-config/tree/main/modules/stacks#input_repository_stacks)
input. Make sure to use a yaml syntax, not hcl/terraform inside the `spacelift.yaml` file.

Here is an example of a `spacelift.yaml` file:

```yaml
contexts:
  nicecxone-oktapreview-com: 0
integrations:
  aws: nice-devops
maintainers:
  - name: system-engineers
    email: systemengineering@nice.com
terraform_version: 1.3.1
```

Since this module is only deployed when pushes are made to the `main` branch you will need to push your `spacelift.yaml`
file into the `main` branch to get a new stack provisioned in spacelift. When creating a new module/stack it is a good idea
to use separate PRs for creating the `spacelift.yaml` file and your terraform configuration. This will allow for the stack
to be created in Spacelift before you merge your terraform configuration, thus allowing a plan to be generated for your
terraform configuration before merging it to branch `main`. Here is the basic process:

1. Create a new branch.
2. Create a the new module/stack directory with a `spacelift.yaml` file and an empty `main.tf` file.
3. Create and merge a PR to branch `main`. This will cause a new stack to be provisioned in Spacelift.
4. Create a new branch.
5. Write your terraform configuration.
6. Create a PR. Review the terraform plan which is generated by Spacelift, then merge your PR to deploy/apply the changes.

## Create an Empty Stack for the first time

If you want to automate the creation of spacelift stack for the first time, got to [this](https://github.com/inContact/infrastructure-live/actions/workflows/new_stack_automation.yaml) link
and run the workflow by providing the below inputs.

**cloud-service-name**: aws or azure cloud name

**infrastructure-type**: cloudformation or terraform type

**account**: aws or azure account name

**region**: aws or azure region name

**main-directory-name**: name of the main directory

**sub-directory-name**: name of the subdirectory. This is not required for azure.

**cloudformation-stack-name**: name of the cloudformation stack if its aws cloud service

**maintainer-name**: gitHub team name

**maintainer-email**: gitHub team email

This will create a PR with required file changes. The one who runs the workflow should go to the pr and review and merge manually if everything looks good.  

Here is the detailed document about how to create a new empty stack - https://github.com/inContact/acddevops-kubernetes-documentation/blob/main/spacelift/empty_stack_creation.md

### Administrative Stacks

Some stacks are used to configure settings, stacks, and other items within the Spacelift platform. These stacks must be granted
administrative permission to be able to execute Spacelift APIs. To grant a stack administrative permission add a path to the
stack in the `administrative_stacks` variable in the [Stacks main.tf](terraform/spacelift/root-stack-provisioner/main.tf).

All stacks which will have administrative privileges must be declared here. This file is owned by the Spacelift administrators
so adding configuration here will force a PR review to be required by the Spacelift administrators.

For example, to grant administrative permission to the `terraform/spacelift/worker-pool-sandbox` stack you would have
something like this:

```yaml
module "stack_provisioner" {
  source  = "spacelift.io/incontact/config/spacelift//modules/stacks"

  administrative_stacks = [
    "terraform/spacelift/worker-pool-sandbox" # add this line
  ]
}
```

## Deletion of Stacks

Deletion protection is enabled for all stacks which are provisioned within Spacelift. This means that if a spacelift.yaml
file has been removed then the deletion of the corresponding stack in Spacelift will fail. This is because deleting
a stack will cause all resources provisioned by the stack to be orphaned.

To delete a stack the following steps should be performed:

1. Create a new branch and add `disable_deletion_protection: true` in the spacelift.yaml file of the stack you want to delete. Create a PR and merge this change into `main`
1. Create a new branch and delete the spacelift.yaml file for the stack. Do NOT delete the terraform or cloudformation files within the stack directory. Create a PR and merge this change into `main`. Merging your PR will trigger a run on the stack-provisioner stack which will trigger a `terraform destroy` or `aws cloudformation delete-stack` followed by deleting the Spacelift stack.
1. Create a new branch and delete the cloudformation or terraform files within your stack directory. Create a PR and merge this change into `main`. Merging this PR will not cause any actions in spacelift because the stack will already be deleted, but this will keep the repository clean.

### Deletion of stacks using workflow

Repos that are moved to spacelift-bot already:

* cicd-iam-service-roles
* spacelift-tutorials
* acddevops-lambda

For the above repositories, if the spacelift stack needs to be deleted, follow the below steps.
1. Before removing the spacelift.yaml, make sure the label called `allow_delete_commands` is present or `execute_only_selected_commands` is removed.
2. Also make sure deletion protection is disabled for the stack. This can be done by adding `disable_deletion_protection: true` in spacelift.yaml file and commit to default branch.
3. If you already removed the spacelift.yaml file, you can add it back and add steps 1 an 2, or you can ask CNC team to do manually.
4. Once done, go [here](https://github.com/inContact/infrastructure-live/actions/workflows/stack_deletion.yaml) to trigger the workflow.
5. Click Run Workflow and pass the spacelift stack id. This can be found in spacelift stack. 
6. Choose the delete option after that. If both the stack and resources needs to be deleted, keep the first option.
7. Run the workflow, it will take care of removing the stack/resource accordingly.
8. Make sure before executing the run, the actor needs to be the maintainer of the stack.
