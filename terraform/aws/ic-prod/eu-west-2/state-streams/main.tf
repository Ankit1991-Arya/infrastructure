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
  region = "eu-west-2"
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
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                              = "em-contact" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"      // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Contact.ContactEvent.V1"
  kafka-output-topic                       = "SuiteData.ContactEvent.V2"
  msk-cluster-name                         = "shared-msk01-eu-west-2"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.ContactEvent.V1"
  deploy-test-kinesis-stream               = false
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "eu-west-2"
  environment-prefix                      = "al"
  security-groups                         = ["sg-07ad9399d024b70db"]
  subnets                                 = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket               = "al-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-al"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                           = "FLINK-1_20"
}

module "state-streams-em-contactV2" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38" // verify and update the version of the module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0" // verify and update the version of the module to deploy
  app-version-type = "tag"

  flink-runtime                            = "FLINK-1_20"
  transformer                              = "em-contact-v2" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"         // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Contact.ContactEvent.V2"
  kafka-output-topic                       = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.ContactEvent.V2"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V2"
  msk-cluster-name                         = "shared-msk01-eu-west-2"
  deploy-test-kinesis-stream               = false
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "eu-west-2"
  environment-prefix                      = "al"
  security-groups                         = ["sg-07ad9399d024b70db"]
  subnets                                 = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket               = "al-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-al"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  dynamodb-table-name                     = "state-streams-state"
  transformer_name_for_state              = "dfo-contact"
  state-request-capacity                  = 1000
}

module "state-streams-mixed-em-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                = "mixed-em-contact" // Name of the State Streams transformer to instantiate
  input-source               = "kafka"            // Either "kafka" or "kinesis"
  kafka-input-topics         = "EntityManagement.Contact.ContactEvent.V1"
  msk-cluster-name           = "shared-msk01-eu-west-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-input-test-topic     = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  snapshots-enabled                        = false
  region                                   = "eu-west-2"
  environment-prefix                       = "am"
  security-groups                          = ["sg-07ad9399d024b70db"]
  subnets                                  = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket                = "al-entitymanagement"
  alarm-sns-topic-name                     = "entitymanagement_alerts_account_prod"
  parallelism                              = 4
  parallelism-per-kpu                      = 1
  schema-registry-ssl-cert-s3-bucket-name  = "ic-certs-al"
  schema-registry-ssl-ca-cert              = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert          = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                            = "FLINK-1_20"
}

module "state-streams-vc-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                = "vc-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "prod-contact"
  deploy-test-kinesis-stream = true
  msk-cluster-name           = "shared-msk01-eu-west-2"
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = false
  region                                              = "eu-west-2"
  environment-prefix                                  = "al"
  security-groups                                     = ["sg-07ad9399d024b70db"]
  subnets                                             = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket                           = "al-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-al"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 3 hours
  efo-registration-type                               = "none"
}

module "state-streams-mixed-vc-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                = "mixed-vc-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "prod-contact"
  msk-cluster-name           = "shared-msk01-eu-west-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = false
  region                                              = "eu-west-2"
  environment-prefix                                  = "al"
  security-groups                                     = ["sg-07ad9399d024b70db"]
  subnets                                             = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket                           = "al-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-al"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 3 hours
  efo-registration-type                               = "none"
}

module "state-streams-dfo-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                = "dfo-contact" // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"
  kinesis-stream-names       = "al-de-case-events-stream" // All the stream names that the flink app will subscribe to
  msk-cluster-name           = "shared-msk01-eu-west-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false // ESC-88786 - issues with certificate
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "eu-west-2"
  environment-prefix                      = "al"
  security-groups                         = ["sg-07ad9399d024b70db"]
  subnets                                 = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket               = "al-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-al"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"

  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 3 hours
  efo-registration-type                               = "none"
  state-request-capacity                              = 1000
}
module "state-streams-dfo-agent-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.29.2"
  app-version-type = "tag"

  transformer                = "dfo-agent-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "prod-agent-session,al-de-platform-events-stream,al-de-case-events-stream"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  msk-cluster-name                         = "shared-msk01-eu-west-2"

  snapshots-enabled                                   = true
  region                                              = "eu-west-2"
  environment-prefix                                  = "al"
  security-groups                                     = ["sg-07ad9399d024b70db"]
  subnets                                             = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket                           = "al-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-al"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600
  efo-registration-type                               = "none"
  state-request-capacity                              = 1000
}

module "state-streams-mixed-dfo-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                = "mixed-dfo-contact" // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"
  kinesis-stream-names       = "al-de-case-events-stream" // All the stream names that the flink app will subscribe to
  msk-cluster-name           = "shared-msk01-eu-west-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false // ESC-88786 - issues with certificate
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "eu-west-2"
  environment-prefix                      = "al"
  security-groups                         = ["sg-07ad9399d024b70db"]
  subnets                                 = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket               = "al-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-al"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"

  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 3 hours
  efo-registration-type                               = "none"
  state-request-capacity                              = 1000
}
module "state-streams-infra" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-infra/default"
  version = "0.9.15" // Version of the Terraform module to deploy

  region             = "eu-west-2"
  environment-prefix = "al"
  security-groups    = ["sg-07ad9399d024b70db"]
  subnets            = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"] // Use Broker service subnets
}

module "state-streams-agent-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0" // Name of the branch or tag to deploy
  app-version-type = "tag"     // Either "branch" or "tag"

  transformer                = "vc-agent-contact"   // Name of the State Streams transformer to instantiate //
  input-source               = "kinesis"            // Either "kafka" or "kinesis"
  kinesis-stream-names       = "prod-agent-contact" // All the stream names that the flink app will subscribe to, delimited by ,
  msk-cluster-name           = "shared-msk01-eu-west-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  schema-registry-url  = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock = false

  schema-registry-auto-register-schemas               = false
  schema-registry-ssl-verification-enabled            = false // ESC-88786 - Disabled due to issues with certificate
  snapshots-enabled                                   = false
  region                                              = "eu-west-2"
  environment-prefix                                  = "al"
  security-groups                                     = ["sg-07ad9399d024b70db"]
  subnets                                             = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket                           = "al-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-al"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 3 hours
}

module "state-streams-multi-event-agent" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-multi-event/default"
  version           = "0.0.21" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.8.0" // Name of the branch or tag to deploy
  app-version-type = "tag"    // Either "branch" or "tag"

  transformer                              = "em-multi-event-agent" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"                // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Agent.AgentEvent.V2"
  kafka-output-topic                       = "SuiteData.AgentSessionEvent.V2"
  kafka-side-output-topic                  = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.AgentSessionEvent.V2"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.AgentEventEMHeartbeat.V2"
  msk-cluster-name                         = "shared-msk01-eu-west-2"
  deploy-test-kinesis-stream               = false
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-url                      = "https://schema-registry-ss-vpce-uk1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "eu-west-2"
  environment-prefix                      = "al"
  security-groups                         = ["sg-07ad9399d024b70db"]
  subnets                                 = ["subnet-0480d9c8cdbe327ac", "subnet-0644aa65b68276a64", "subnet-0f3ce283d1cbe72b3"]
  build-artifacts-s3-bucket               = "al-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-al"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                           = "FLINK-1_20"
  state-request-capacity                  = 1000
  transformer_name_for_state              = "dfo-agent-contact"
}
