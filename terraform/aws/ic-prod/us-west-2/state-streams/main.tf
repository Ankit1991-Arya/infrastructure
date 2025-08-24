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
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                              = "em-contact" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"      // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Contact.ContactEvent.V1"
  kafka-output-topic                       = "SuiteData.ContactEvent.V2"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.ContactEvent.V1"
  deploy-test-kinesis-stream               = false
  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "ao"
  security-groups                         = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                 = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket               = "ao-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ao"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                           = "FLINK-1_20"
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
  deploy-test-kinesis-stream = false
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-input-test-topic     = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "ao"
  security-groups                         = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                 = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket               = "ao-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ao"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                           = "FLINK-1_20"
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
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = true
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "ao"
  security-groups                                     = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                             = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket                           = "ao-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-ao"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 15 hours
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
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = true
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "ao"
  security-groups                                     = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                             = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket                           = "ao-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-ao"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 15 hours
  efo-registration-type                               = "none"
}

module "state-streams-dfo-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                = "dfo-contact"              // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                  // Either "kafka" or "kinesis"
  kinesis-stream-names       = "ao-de-case-events-stream" // All the stream names that the flink app will subscribe to
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = true
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "ao"
  security-groups                                     = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                             = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket                           = "ao-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-ao"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  orchestration-host                                  = "entitymanagement-ss-vpce-na1.omnichannel.prod.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 15 hours
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
  kinesis-stream-names       = "prod-agent-session,ao-de-platform-events-stream,ao-de-case-events-stream"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = true
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "ao"
  security-groups                                     = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                             = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket                           = "ao-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-ao"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  orchestration-host                                  = "entitymanagement-ss-vpce-na1.omnichannel.prod.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 15 hours
  efo-registration-type                               = "none"
  state-request-capacity                              = 1000
}

module "state-streams-mixed-dfo-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                = "mixed-dfo-contact"        // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                  // Either "kafka" or "kinesis"
  kinesis-stream-names       = "ao-de-case-events-stream" // All the stream names that the flink app will subscribe to
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-ssl-verification-enabled = true
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "ao"
  security-groups                                     = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                             = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket                           = "ao-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-ao"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  orchestration-host                                  = "entitymanagement-ss-vpce-na1.omnichannel.prod.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 15 hours
  efo-registration-type                               = "none"
  state-request-capacity                              = 1000
}

module "state-streams-infra" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-infra/default"
  version = "0.9.15" // Version of the Terraform module to deploy

  region             = "us-west-2"
  environment-prefix = "ao"
  subnets            = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"] // Use Broker service subnets
  security-groups    = ["sg-0b2b942e5bbcc8e6f"]

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
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  schema-registry-url  = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock = false

  schema-registry-auto-register-schemas               = false
  schema-registry-ssl-verification-enabled            = true
  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "ao"
  security-groups                                     = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                             = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket                           = "ao-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_prod"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-ao"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 15 hours
}

module "state-streams-multi-event-agent" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-multi-event/default"
  version           = "0.0.21" // Version of the Terraform module to deploy
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
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = true

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "ao"
  security-groups                         = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                 = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket               = "ao-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ao"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  state-request-capacity                  = 1000
  transformer_name_for_state              = "dfo-agent-contact"
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
  deploy-test-kinesis-stream               = false
  schema-registry-ssl-verification-enabled = true
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.prod.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "ao"
  security-groups                         = ["sg-0b2b942e5bbcc8e6f"]
  subnets                                 = ["subnet-096a3692b6e65e09b", "subnet-08d881d3ead9e32a3", "subnet-0668284494f4e5954"]
  build-artifacts-s3-bucket               = "ao-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_prod"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ao"
  schema-registry-ssl-ca-cert             = "star_omnichannel_prod_internal/lax-incer01.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_prod_internal/star.omnichannel.prod.internal.cer"
  dynamodb-table-name                     = "state-streams-state"
  transformer_name_for_state              = "dfo-contact"
  state-request-capacity                  = 1000
}
