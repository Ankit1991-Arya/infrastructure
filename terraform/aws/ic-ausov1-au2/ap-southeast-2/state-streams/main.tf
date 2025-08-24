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
  region = "ap-southeast-2"
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
  msk-cluster-name                         = "shared-msk01-ap-southeast-2"
  deploy-test-kinesis-stream               = false
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"
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
  msk-cluster-name           = "shared-msk01-ap-southeast-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-input-test-topic     = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"
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
  msk-cluster-name           = "shared-msk01-ap-southeast-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"

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
  msk-cluster-name           = "shared-msk01-ap-southeast-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"

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

  transformer                = "dfo-contact"                // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                    // Either "kafka" or "kinesis"
  kinesis-stream-names       = "ausy-de-case-events-stream" // All the stream names that the flink app will subscribe to
  msk-cluster-name           = "shared-msk01-ap-southeast-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"
  orchestration-host                      = "entitymanagement-ss-vpce-au2.omnichannel.ausov1.internal"
  flink-runtime                           = "FLINK-1_20"
  orchestration-port                      = 443
  orchestration-request-timeout-ms        = 500
  orchestration-requests-enabled          = false

  kinesis-initial-position-offset-from-latest-seconds = 3600 # 3 hours
  efo-registration-type                               = "none"
  state-request-capacity                              = 1000
}

module "state-streams-mixed-dfo-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0"
  app-version-type = "tag"

  transformer                = "mixed-dfo-contact"          // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                    // Either "kafka" or "kinesis"
  kinesis-stream-names       = "ausy-de-case-events-stream" // All the stream names that the flink app will subscribe to
  msk-cluster-name           = "shared-msk01-ap-southeast-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"
  orchestration-host                      = "entitymanagement-ss-vpce-au2.omnichannel.ausov1.internal"
  orchestration-port                      = 443
  orchestration-request-timeout-ms        = 500
  orchestration-requests-enabled          = false
  flink-runtime                           = "FLINK-1_20"

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
  kinesis-stream-names       = "prod-agent-session,ausy-de-platform-events-stream,ausy-de-case-events-stream"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-ssl-verification-enabled = false
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  msk-cluster-name                         = "shared-msk01-ap-southeast-2"

  snapshots-enabled                                   = true
  region                                              = "ap-southeast-2"
  environment-prefix                                  = "ausy"
  security-groups                                     = ["sg-037d1f8a5382f5aa3"]
  subnets                                             = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket                           = "ausy-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_ausov1"
  parallelism                                         = 4
  parallelism-per-kpu                                 = 1
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-ausy"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"
  orchestration-host                                  = "entitymanagement-ss-vpce-au2.omnichannel.ausov1.internal"
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

  region             = "ap-southeast-2"
  environment-prefix = "ausy"
  security-groups    = ["sg-037d1f8a5382f5aa3"]
  subnets            = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"] // Use Broker service subnets
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
  msk-cluster-name           = "shared-msk01-ap-southeast-2"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = false // ESC-88786 - Disabled due to issues with certificate

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"

  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = 3600 # 3 hours
}

module "state-streams-multi-event-agent" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-multi-event/default"
  version           = "0.0.21" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.8.0" // Name of the branch or tag to deploy
  app-version-type = "tag"    // Either "branch" or "tag"

  flink-runtime              = "FLINK-1_20"
  transformer                = "em-multi-event-agent" // Name of the State Streams transformer to instantiate
  input-source               = "kafka"                // Either "kafka" or "kinesis"
  kafka-input-topics         = "EntityManagement.Agent.AgentEvent.V2"
  kafka-output-topic         = "SuiteData.AgentSessionEvent.V2"
  kafka-side-output-topic    = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentSessionEvent.V2"
  kafka-input-test-topic     = "SuiteData.IntegrationTests.AgentEventEMHeartbeat.V2"
  deploy-test-kinesis-stream = false

  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = false
  msk-cluster-name                         = "shared-msk01-ap-southeast-2"

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"
  state-request-capacity                  = 1000
  transformer_name_for_state              = "dfo-agent-contact"
}


module "state-streams-em-contactV2" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.11.38" // verify and update the version of the module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.28.0" // verify and update the version of the module to deploy
  app-version-type = "tag"

  flink-runtime              = "FLINK-1_20"
  transformer                = "em-contact-v2" // Name of the State Streams transformer to instantiate
  input-source               = "kafka"         // Either "kafka" or "kinesis"
  kafka-input-topics         = "EntityManagement.Contact.ContactEvent.V2"
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V2"
  kafka-input-test-topic     = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V2"
  deploy-test-kinesis-stream = false

  schema-registry-ssl-verification-enabled = false
  schema-registry-url                      = "https://schema-registry-ss-vpce-au2.omnichannel.ausov1.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  msk-cluster-name                         = "shared-msk01-ap-southeast-2"

  snapshots-enabled                       = false
  region                                  = "ap-southeast-2"
  environment-prefix                      = "ausy"
  security-groups                         = ["sg-037d1f8a5382f5aa3"]
  subnets                                 = ["subnet-0af8eb84de6ab6b59", "subnet-0f0efe40e165994b2", "subnet-07bcd94c51c90aa3d"]
  build-artifacts-s3-bucket               = "ausy-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_ausov1"
  parallelism                             = 4
  parallelism-per-kpu                     = 1
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-ausy"
  schema-registry-ssl-ca-cert             = "star_omnichannel_ausov1_internal/AUSOV1-AUSYA-INCER01-CA.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_ausov1_internal/star.omnichannel.ausov1.internal.cer"

  kinesis-initial-position-offset-from-latest-seconds = 3600 # 3 hours
  dynamodb-table-name                                 = "state-streams-state"
  transformer_name_for_state                          = "dfo-contact"
  state-request-capacity                              = 1000
}
