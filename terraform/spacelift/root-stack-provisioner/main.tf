terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.1.0"
    }
  }
}

provider "spacelift" {
  api_key_endpoint = "https://incontact.app.spacelift.io"
}

module "root_stack_provisioner" {
  source  = "spacelift.io/incontact/config/spacelift//modules/root-stack-provisioner"
  version = "~> 3.13" # This means that terraform will automatically pull the latest feature version (the 2nd digit in the version)

  # All stacks which will have administrative privileges must be declared here. This file is owned by the spacelift administrators
  # so adding configuration here will force a review to be required by the spacelift administrators.
  repositories = {
    "inContact/acddevops-kubernetes" = {
      administrative_stacks = []
      branch                = "main"
      project_root          = ""
      stack_labels          = []
      modules_only          = false
    }
    "inContact/acd-clusters" = {
      administrative_stacks = []
      branch                = "main"
      project_root          = ""
      stack_labels          = []
      modules_only          = false
    }
    "inContact/cnc-spacelift-test-validations" = {
      administrative_stacks = []
      branch                = "main"
      project_root          = ""
      stack_labels          = []
      modules_only          = false
    }
    "inContact/dba-aurora-db" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = false
    }
    "inContact/media-services-pocredirector" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/digital-first-workflow-ewt-lambdas" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/digital-first-workflow-dfo-poc-updater-lambda" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/digital-first-workflow-onreskill-message-relay-lambda" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/ProviderESN" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/media-services-tools" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/aws-terraform-modules-network" = {
      administrative_stacks = []
      branch                = "main"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/dfo-terraform-modules" = {
      administrative_stacks = []
      branch                = "main"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/openapm-terraform-modules" = {
      administrative_stacks = []
      branch                = "main"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/media-services-configurator" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/aws-terraform-modules-systems" = {
      administrative_stacks = []
      branch                = "main"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/orch-entity-state-streams" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/terraform-modules-cloudops" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
    "inContact/terraform-modules-msk" = {
      administrative_stacks = []
      branch                = "master"
      project_root          = ""
      stack_labels          = []
      modules_only          = true
    }
  }
}
