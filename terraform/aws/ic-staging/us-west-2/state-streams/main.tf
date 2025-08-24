terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "ESC / esc@niceincontact.com"
      InfrastructureOwner = "ESC / esc@niceincontact.com"
      Product             = "entitymanagement"
      Service             = "State Streams"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}

module "state-streams-em-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                              = "em-contact" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"      // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Contact.ContactEvent.V1"
  kafka-output-topic                       = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.ContactEvent.V1"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  deploy-test-kinesis-stream               = false
  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "so"
  security-groups                         = ["sg-049e40d74fdae0c8b"]
  subnets                                 = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket               = "so-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_staging"
  parallelism                             = "8"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-so"
  schema-registry-ssl-ca-cert             = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"
  flink-runtime                           = "FLINK-1_20"
  allow-non-restored-state                = "false"
}

module "state-streams-vc-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "vc-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "staging-contact"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "so"
  security-groups                                     = ["sg-049e40d74fdae0c8b"]
  subnets                                             = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket                           = "so-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_staging"
  parallelism                                         = "16"
  parallelism-per-kpu                                 = "4"
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-so"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  allow-non-restored-state                            = "false"
}

module "state-streams-infra" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-infra/default"
  version = "0.10.1" // Version of the Terraform module to deploy

  region             = "us-west-2"
  environment-prefix = "so"
  subnets            = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"] // Use Broken service subnets
}

module "state-streams-mixed-em-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "mixed-em-contact" // Name of the State Streams transformer to instantiate
  input-source               = "kafka"            // Either "kafka" or "kinesis"
  kafka-input-topics         = "EntityManagement.Contact.ContactEvent.V1"
  deploy-test-kinesis-stream = false
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-input-test-topic     = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "so"
  security-groups                         = ["sg-049e40d74fdae0c8b"]
  subnets                                 = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket               = "so-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_staging"
  parallelism                             = "8"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-so"
  schema-registry-ssl-ca-cert             = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"
  flink-runtime                           = "FLINK-1_20"
  allow-non-restored-state                = "false"
}

module "state-streams-mixed-vc-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "mixed-vc-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "staging-contact"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "so"
  security-groups                                     = ["sg-049e40d74fdae0c8b"]
  subnets                                             = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket                           = "so-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_staging"
  parallelism                                         = "16"
  parallelism-per-kpu                                 = "4"
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-so"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  allow-non-restored-state                            = "false"
}

module "state-streams-dfo-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "dfo-contact"              // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                  // Either "kafka" or "kinesis"
  kinesis-stream-names       = "so-de-case-events-stream" // All the stream names that the flink app will subscribe to
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = true
  region                                  = "us-west-2"
  environment-prefix                      = "so"
  security-groups                         = ["sg-049e40d74fdae0c8b"]
  subnets                                 = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket               = "so-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_staging"
  parallelism                             = "16"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-so"
  schema-registry-ssl-ca-cert             = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"

  orchestration-host                                  = "entitymanagement-griffin-ss-vpce-na1.omnichannel.staging.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  state-request-capacity                              = "1000"
  allow-non-restored-state                            = "false"
}

module "state-streams-dfo-agent-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.31.0"
  app-version-type = "tag"

  transformer                = "dfo-agent-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "staging-agent-session,so-de-platform-events-stream,so-de-case-events-stream"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = true
  region                                  = "us-west-2"
  environment-prefix                      = "so"
  security-groups                         = ["sg-049e40d74fdae0c8b"]
  subnets                                 = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket               = "so-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_staging"
  parallelism                             = "16"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-so"
  schema-registry-ssl-ca-cert             = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"

  orchestration-host                                  = "entitymanagement-griffin-ss-vpce-na1.omnichannel.staging.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  state-request-capacity                              = "1000"
  allow-non-restored-state                            = "false"
}

module "state-streams-mixed-dfo-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "mixed-dfo-contact"        // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                  // Either "kafka" or "kinesis"
  kinesis-stream-names       = "so-de-case-events-stream" // All the stream names that the flink app will subscribe to
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = true
  region                                  = "us-west-2"
  environment-prefix                      = "so"
  security-groups                         = ["sg-049e40d74fdae0c8b"]
  subnets                                 = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket               = "so-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_staging"
  parallelism                             = "16"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-so"
  schema-registry-ssl-ca-cert             = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"

  orchestration-host                                  = "entitymanagement-griffin-ss-vpce-na1.omnichannel.staging.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  state-request-capacity                              = "1000"
  allow-non-restored-state                            = "false"
}

module "state-streams-agent-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0" // Name of the branch or tag to deploy
  app-version-type = "tag"     // Either "branch" or "tag"

  transformer                = "vc-agent-contact"      // Name of the State Streams transformer to instantiate //
  input-source               = "kinesis"               // Either "kafka" or "kinesis"
  kinesis-stream-names       = "staging-agent-contact" // All the stream names that the flink app will subscribe to, delimited by ,
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  schema-registry-url  = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock = false


  schema-registry-auto-register-schemas               = false
  schema-registry-ssl-verification-enabled            = true
  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "so"
  security-groups                                     = ["sg-049e40d74fdae0c8b"]
  subnets                                             = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket                           = "so-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_staging"
  parallelism                                         = "16"
  parallelism-per-kpu                                 = "4"
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-so"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  allow-non-restored-state                            = "false"
}

module "state-streams-em-contactV2" {
  // Note that changing between "orch-entity-state-streams" and "orch-entity-state-streams-development" causes the app to be recreated
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0" // Name of the branch or tag to deploy
  app-version-type = "tag"     // Either "branch" or "tag"

  flink-runtime                            = "FLINK-1_20"
  transformer                              = "em-contact-v2" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"         // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Contact.ContactEvent.V2"
  kafka-output-topic                       = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.ContactEvent.V2"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V2"
  deploy-test-kinesis-stream               = false
  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "so"
  security-groups                         = ["sg-049e40d74fdae0c8b"]
  subnets                                 = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket               = "so-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_staging"
  parallelism                             = "8"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-so"
  schema-registry-ssl-ca-cert             = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"
  dynamodb-table-name                     = "state-streams-state"
  transformer_name_for_state              = "dfo-contact"
  state-request-capacity                  = "1000"
  allow-non-restored-state                = "false"
}

module "state-streams-multi-event-agent" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-multi-event/default"
  version           = "0.0.22" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.8.0" // Name of the branch or tag to deploy
  app-version-type = "tag"    // Either "branch" or "tag"

  flink-runtime                            = "FLINK-1_20"
  transformer                              = "em-multi-event-agent" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"                // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Agent.AgentEvent.V2"
  kafka-output-topic                       = "SuiteData.AgentSessionEvent.V2"
  kafka-side-output-topic                  = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.AgentSessionEvent.V2"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.AgentEventEMHeartbeat.V2"
  deploy-test-kinesis-stream               = false
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.staging.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = true

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "so"
  security-groups                         = ["sg-049e40d74fdae0c8b"]
  subnets                                 = ["subnet-09d7b175ecc0a8a2b", "subnet-0f394298136b07d11", "subnet-01f03eda6621d9bb2"]
  build-artifacts-s3-bucket               = "so-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_staging"
  parallelism                             = "8"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-so"
  schema-registry-ssl-ca-cert             = "star_omnichannel_staging_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_staging_internal/star.omnichannel.staging.internal.cer"
  state-request-capacity                  = "1000"
  transformer_name_for_state              = "dfo-agent-contact"
  allow-non-restored-state                = "false"
}
