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
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "to"
  security-groups                         = ["sg-0d7968a11a28b644f"]
  subnets                                 = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"]
  build-artifacts-s3-bucket               = "to-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_test"
  parallelism                             = "8"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-to"
  schema-registry-ssl-ca-cert             = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"
  flink-runtime                           = "FLINK-1_20"
  # allow-non-restored-state                = "true"
  allow-non-restored-state = "true"
}

module "state-streams-vc-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "vc-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "test-contact"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = true

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "to"
  security-groups                                     = ["sg-0d7968a11a28b644f"]
  subnets                                             = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"]
  build-artifacts-s3-bucket                           = "to-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_test"
  parallelism                                         = "16"
  parallelism-per-kpu                                 = "4"
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-to"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  allow-non-restored-state                            = "true"
}

module "state-streams-infra" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-infra/default"
  version = "0.10.1" // Version of the Terraform module to deploy

  region             = "us-west-2"
  environment-prefix = "to"
  subnets            = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"]
}

module "state-streams-dfo-contact" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version = "0.12.2"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "dfo-contact"              // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                  // Either "kafka" or "kinesis"
  kinesis-stream-names       = "to-de-case-events-stream" // All the stream names that the flink app will subscribe to
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.ContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = true

  snapshots-enabled                       = true
  application-owner                       = "ESC / esc@niceincontact.com"
  region                                  = "us-west-2"
  environment-prefix                      = "to"
  security-groups                         = ["sg-0d7968a11a28b644f"]                                                             // Broker Service security group
  subnets                                 = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"] // Broker Service subnets
  build-artifacts-s3-bucket               = "to-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_test"
  parallelism                             = "16"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-to"
  schema-registry-ssl-ca-cert             = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"

  orchestration-host                                  = "entitymanagement-griffin-ss-vpce-na1.omnichannel.test.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  state-request-capacity                              = "1000"
  # allow-non-restored-state                            = "true"
  allow-non-restored-state = "true"
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
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "to"
  security-groups                         = ["sg-0d7968a11a28b644f"]
  subnets                                 = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"]
  build-artifacts-s3-bucket               = "to-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_test"
  parallelism                             = "8"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-to"
  schema-registry-ssl-ca-cert             = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"
  flink-runtime                           = "FLINK-1_20"
  # allow-non-restored-state                = "true"
  allow-non-restored-state = "true"
}

module "state-streams-mixed-vc-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "mixed-vc-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "test-contact"
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = true

  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "to"
  security-groups                                     = ["sg-0d7968a11a28b644f"]
  subnets                                             = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"]
  build-artifacts-s3-bucket                           = "to-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_test"
  parallelism                                         = "16"
  parallelism-per-kpu                                 = "4"
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-to"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  # allow-non-restored-state                            = "true"
  allow-non-restored-state = "true"
}

module "state-streams-mixed-dfo-contact" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version = "0.12.2"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  transformer                = "mixed-dfo-contact"        // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                  // Either "kafka" or "kinesis"
  kinesis-stream-names       = "to-de-case-events-stream" // All the stream names that the flink app will subscribe to
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = true

  snapshots-enabled                       = true
  application-owner                       = "ESC / esc@niceincontact.com"
  region                                  = "us-west-2"
  environment-prefix                      = "to"
  security-groups                         = ["sg-0d7968a11a28b644f"]                                                             // Broker Service security group
  subnets                                 = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"] // Broker Service subnets
  build-artifacts-s3-bucket               = "to-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_test"
  parallelism                             = "16"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-to"
  schema-registry-ssl-ca-cert             = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"

  orchestration-host                                  = "entitymanagement-griffin-ss-vpce-na1.omnichannel.test.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  efo-registration-type                               = "none"
  state-request-capacity                              = "1000"
  # allow-non-restored-state                            = "true"
  allow-non-restored-state = "true"
}

module "state-streams-dfo-agent-contact" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version = "0.12.2"

  app-version      = "v0.31.0"
  app-version-type = "tag"
  flink-runtime    = "FLINK-1_20"

  transformer                = "dfo-agent-contact"
  input-source               = "kinesis"
  kinesis-stream-names       = "test-agent-session,to-de-platform-events-stream,to-de-case-events-stream"
  deploy-test-kinesis-stream = true
  efo-registration-type      = "none"
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = true

  snapshots-enabled                       = true
  application-owner                       = "ESC / esc@niceincontact.com"
  region                                  = "us-west-2"
  environment-prefix                      = "to"
  security-groups                         = ["sg-0d7968a11a28b644f"]                                                             // Broker Service security group
  subnets                                 = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"] // Broker Service subnets
  build-artifacts-s3-bucket               = "to-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_test"
  parallelism                             = "16"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-to"
  schema-registry-ssl-ca-cert             = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"

  orchestration-host                                  = "entitymanagement-griffin-ss-vpce-na1.omnichannel.test.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = false
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  state-request-capacity                              = "1000"
  # allow-non-restored-state                            = "true"
  allow-non-restored-state = "true"
}


module "state-streams-agent-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"
  log-level        = "DEBUG"

  transformer                = "vc-agent-contact"   // Name of the State Streams transformer to instantiate //
  input-source               = "kinesis"            // Either "kafka" or "kinesis"
  kinesis-stream-names       = "test-agent-contact" // All the stream names that the flink app will subscribe to, delimited by ,
  deploy-test-kinesis-stream = true
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  schema-registry-url                                 = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                                = false
  schema-registry-auto-register-schemas               = false
  schema-registry-ssl-verification-enabled            = true
  snapshots-enabled                                   = true
  region                                              = "us-west-2"
  environment-prefix                                  = "to"
  security-groups                                     = ["sg-0d7968a11a28b644f"]                                                             // Broker Service security group
  subnets                                             = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"] // Broker Service subnets
  build-artifacts-s3-bucket                           = "to-entitymanagement"
  alarm-sns-topic-name                                = "entitymanagement_alerts_account_test"
  parallelism                                         = "16"
  parallelism-per-kpu                                 = "4"
  schema-registry-ssl-cert-s3-bucket-name             = "ic-certs-to"
  schema-registry-ssl-ca-cert                         = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert                     = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"
  flink-runtime                                       = "FLINK-1_20"
  kinesis-initial-position-offset-from-latest-seconds = "3600"
  # allow-non-restored-state                            = "true"
  allow-non-restored-state = "true"
}

module "state-streams-em-contactV2" {
  // Note that changing between "orch-entity-state-streams" and "orch-entity-state-streams-development" causes the app to be recreated
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams/default"
  version           = "0.12.2"
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.30.0"
  app-version-type = "tag"

  flink-runtime                         = "FLINK-1_20"
  transformer                           = "em-contact-v2" // Name of the State Streams transformer to instantiate
  input-source                          = "kafka"         // Either "kafka" or "kinesis"
  kafka-input-topics                    = "EntityManagement.Contact.ContactEvent.V2"
  kafka-output-topic                    = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic               = "SuiteData.IntegrationTests.ContactEvent.V2"
  kafka-input-test-topic                = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V2"
  deploy-test-kinesis-stream            = false
  schema-registry-url                   = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                  = false
  schema-registry-auto-register-schemas = false

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "to"
  security-groups                         = ["sg-0d7968a11a28b644f"]
  subnets                                 = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"]
  build-artifacts-s3-bucket               = "to-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_test"
  parallelism                             = "8"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-to"
  schema-registry-ssl-ca-cert             = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"
  transformer_name_for_state              = "dfo-contact"
  dynamodb-table-name                     = "state-streams-state"
  state-request-capacity                  = "1000"
  # allow-non-restored-state                = "true"
  allow-non-restored-state = "true"
}

module "state-streams-multi-event-agent" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-multi-event/default"
  version           = "0.0.22" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "v0.8.0" // Name of the branch or tag to deploy
  app-version-type = "tag"    // Either "branch" or "tag"

  log-level                                = "DEBUG"
  flink-runtime                            = "FLINK-1_20"
  transformer                              = "em-multi-event-agent" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"                // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Agent.AgentEvent.V2"
  kafka-output-topic                       = "SuiteData.AgentSessionEvent.V2"
  kafka-side-output-topic                  = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.AgentSessionEvent.V2"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.AgentEventEMHeartbeat.V2"
  deploy-test-kinesis-stream               = false
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.test.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = true

  snapshots-enabled                       = false
  region                                  = "us-west-2"
  environment-prefix                      = "to"
  security-groups                         = ["sg-0d7968a11a28b644f"]
  subnets                                 = ["subnet-0fb0813d5521b23cb", "subnet-0b035436991b45f26", "subnet-01791f7847534b6e5"]
  build-artifacts-s3-bucket               = "to-entitymanagement"
  alarm-sns-topic-name                    = "entitymanagement_alerts_account_test"
  parallelism                             = "8"
  parallelism-per-kpu                     = "4"
  schema-registry-ssl-cert-s3-bucket-name = "ic-certs-to"
  schema-registry-ssl-ca-cert             = "star_omnichannel_test_internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert         = "star_omnichannel_test_internal/star.omnichannel.test.internal.cer"
  state-request-capacity                  = "1000"
  transformer_name_for_state              = "dfo-agent-contact"
  # allow-non-restored-state                = "true"
  allow-non-restored-state = "true"
}
