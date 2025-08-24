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
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version = "0.12.7" // Version of the Terraform module to deploy

  app-version      = "development" // Name of the branch or tag to deploy
  app-version-type = "branch"      // Either "branch" or "tag"
  log-level        = "DEBUG"
  flink-runtime    = "FLINK-1_20"

  transformer                           = "em-contact" // Name of the State Streams transformer to instantiate
  input-source                          = "kafka"      // Either "kafka" or "kinesis"
  kafka-input-topics                    = "EntityManagement.Contact.ContactEvent.V1,EntityManagement.Griffin.Contact.ContactEvent.V1,EntityManagement.Hydra.Contact.ContactEvent.V1,EntityManagement.Kraken.Contact.ContactEvent.V1,EntityManagement.Phoenix.Contact.ContactEvent.V1,EntityManagement.Trojanhorse.Contact.ContactEvent.V1,EntityManagement.Werewolf.Contact.ContactEvent.V1,EntityManagement.Yeti.Contact.ContactEvent.V1,EntityManagement.Unicorn.Contact.ContactEvent.V1,EntityManagement.Werewolf.Contact.ContactEvent.V1"
  kafka-output-topic                    = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic               = "SuiteData.IntegrationTests.ContactEvent.V1"
  kafka-input-test-topic                = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  deploy-test-kinesis-stream            = false
  schema-registry-url                   = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                  = false
  schema-registry-auto-register-schemas = false

  snapshots-enabled                        = false
  region                                   = "us-west-2"
  environment-prefix                       = "do"
  security-groups                          = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                                  = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket                = "do-entitymanagement"
  parallelism                              = 4
  parallelism-per-kpu                      = 4
  auto-scaling-enabled                     = false
  schema-registry-ssl-cert-s3-bucket-name  = "ic-certs-do"
  schema-registry-ssl-ca-cert              = "star.omnichannel.dev.internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert          = "star.omnichannel.dev.internal/star.omnichannel.dev.internal.cer"
  schema-registry-ssl-verification-enabled = false
  environment                              = "ic-dev"
}

module "state-streams-vc-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version           = "0.12.7" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "development" // Name of the branch or tag to deploy
  app-version-type = "branch"      // Either "branch" or "tag"
  log-level        = "DEBUG"
  flink-runtime    = "FLINK-1_20"

  transformer                                         = "vc-contact"  // Name of the State Streams transformer to instantiate
  input-source                                        = "kinesis"     // Either "kafka" or "kinesis"
  kinesis-stream-names                                = "dev-contact" // All the stream names that the flink app will subscribe to, delimited by ,
  kinesis-initial-position-offset-from-latest-seconds = 3600
  deploy-test-kinesis-stream                          = true
  efo-registration-type                               = "lazy"
  kafka-input-topics                                  = "entitymanagement-contact-event"
  kafka-output-topic                                  = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic                             = "SuiteData.IntegrationTests.ContactEvent.V1"

  schema-registry-url                   = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                  = false
  schema-registry-auto-register-schemas = false

  snapshots-enabled                        = true
  region                                   = "us-west-2"
  environment-prefix                       = "do"
  security-groups                          = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                                  = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket                = "do-entitymanagement"
  parallelism                              = 4
  parallelism-per-kpu                      = 4
  auto-scaling-enabled                     = false
  schema-registry-ssl-cert-s3-bucket-name  = "ic-certs-do"
  schema-registry-ssl-ca-cert              = "star.omnichannel.dev.internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert          = "star.omnichannel.dev.internal/star.omnichannel.dev.internal.cer"
  schema-registry-ssl-verification-enabled = false
  environment                              = "ic-dev"
}

module "state-streams-mixed-vc-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version           = "0.12.7" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "development" // Name of the branch or tag to deploy
  app-version-type = "branch"      // Either "branch" or "tag"
  log-level        = "DEBUG"
  flink-runtime    = "FLINK-1_20"

  transformer                                         = "mixed-vc-contact" // Name of the State Streams transformer to instantiate
  input-source                                        = "kinesis"          // Either "kafka" or "kinesis"
  kinesis-stream-names                                = "dev-contact"      // All the stream names that the flink app will subscribe to, delimited by ,
  kinesis-initial-position-offset-from-latest-seconds = 3600
  deploy-test-kinesis-stream                          = true
  efo-registration-type                               = "lazy"
  kafka-input-topics                                  = "entitymanagement-contact-event"
  kafka-output-topic                                  = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic                             = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                   = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                  = false
  schema-registry-auto-register-schemas = false

  snapshots-enabled                        = true
  region                                   = "us-west-2"
  environment-prefix                       = "do"
  security-groups                          = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                                  = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket                = "do-entitymanagement"
  parallelism                              = 4
  parallelism-per-kpu                      = 4
  auto-scaling-enabled                     = false
  schema-registry-ssl-cert-s3-bucket-name  = "ic-certs-do"
  schema-registry-ssl-ca-cert              = "star.omnichannel.dev.internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert          = "star.omnichannel.dev.internal/star.omnichannel.dev.internal.cer"
  schema-registry-ssl-verification-enabled = false
  environment                              = "ic-dev"
}

module "state-streams-mixed-em-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version           = "0.12.7" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "development" // Name of the branch or tag to deploy
  app-version-type = "branch"      // Either "branch" or "tag"
  log-level        = "DEBUG"
  flink-runtime    = "FLINK-1_20"

  transformer                = "mixed-em-contact" // Name of the State Streams transformer to instantiate
  input-source               = "kafka"            // Either "kafka" or "kinesis"
  kafka-input-topics         = "EntityManagement.Contact.ContactEvent.V1,EntityManagement.Griffin.Contact.ContactEvent.V1,EntityManagement.Hydra.Contact.ContactEvent.V1,EntityManagement.Kraken.Contact.ContactEvent.V1,EntityManagement.Phoenix.Contact.ContactEvent.V1,EntityManagement.Trojanhorse.Contact.ContactEvent.V1,EntityManagement.Yeti.Contact.ContactEvent.V1,EntityManagement.Werewolf.Contact.ContactEvent.V1,EntityManagement.Unicorn.Contact.ContactEvent.V1"
  deploy-test-kinesis-stream = false
  kafka-output-topic         = "SuiteData.MixedContactEvent.V2"
  kafka-input-test-topic     = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V1"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  schema-registry-url                   = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                  = false
  schema-registry-auto-register-schemas = false

  snapshots-enabled                        = false
  region                                   = "us-west-2"
  environment-prefix                       = "do"
  security-groups                          = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                                  = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket                = "do-entitymanagement"
  parallelism                              = 4
  parallelism-per-kpu                      = 4
  auto-scaling-enabled                     = false
  schema-registry-ssl-cert-s3-bucket-name  = "ic-certs-do"
  schema-registry-ssl-ca-cert              = "star.omnichannel.dev.internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert          = "star.omnichannel.dev.internal/star.omnichannel.dev.internal.cer"
  schema-registry-ssl-verification-enabled = false
  environment                              = "ic-dev"
}

module "state-streams-agent-contact" {
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version           = "0.12.7" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version      = "development" // Name of the branch or tag to deploy
  app-version-type = "branch"      // Either "branch" or "tag"
  log-level        = "DEBUG"
  flink-runtime    = "FLINK-1_20"


  transformer                                         = "vc-agent-contact"  // Name of the State Streams transformer to instantiate //
  input-source                                        = "kinesis"           // Either "kafka" or "kinesis"
  kinesis-stream-names                                = "dev-agent-contact" // All the stream names that the flink app will subscribe to, delimited by ,
  kinesis-initial-position-offset-from-latest-seconds = 3600
  deploy-test-kinesis-stream                          = true
  schema-registry-url                                 = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                                = false
  schema-registry-auto-register-schemas               = false
  kafka-test-output-topic                             = "SuiteData.IntegrationTests.AgentContactEvent.V1"
  kafka-input-topics                                  = "entitymanagement-contact-event" // doesnt matter here
  kafka-output-topic                                  = "SuiteData.AgentContactEvent.V2"

  snapshots-enabled         = true
  region                    = "us-west-2"
  environment-prefix        = "do"
  security-groups           = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                   = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket = "do-entitymanagement"
  parallelism               = 4
  parallelism-per-kpu       = 4
  auto-scaling-enabled      = false

  schema-registry-ssl-cert-s3-bucket-name  = "ic-certs-do"
  schema-registry-ssl-ca-cert              = "star.omnichannel.dev.internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert          = "star.omnichannel.dev.internal/star.omnichannel.dev.internal.cer"
  schema-registry-ssl-verification-enabled = false
  environment                              = "ic-dev"
}

module "state-streams-dfo-contact" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version = "0.12.7" // Version of the Terraform module to deploy

  app-version      = "development" // Name of the branch or tag to deploy
  app-version-type = "branch"      // Either "branch" or "tag"
  log-level        = "DEBUG"
  flink-runtime    = "FLINK-1_20"

  transformer                                         = "dfo-contact"              // Name of the State Streams transformer to instantiate
  input-source                                        = "kinesis"                  // Either "kafka" or "kinesis"
  kinesis-stream-names                                = "do-de-case-events-stream" // All the stream names that the flink app will subscribe to
  kinesis-initial-position-offset-from-latest-seconds = 3600
  deploy-test-kinesis-stream                          = true
  efo-registration-type                               = "lazy"
  kafka-output-topic                                  = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic                             = "SuiteData.IntegrationTests.ContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = false

  snapshots-enabled         = true
  application-owner         = "ESC / esc@niceincontact.com"
  region                    = "us-west-2"
  environment-prefix        = "do"
  security-groups           = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                   = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket = "do-entitymanagement"
  parallelism               = 4
  parallelism-per-kpu       = 4
  auto-scaling-enabled      = false

  orchestration-host                     = "entitymanagement-griffin-ss-vpce-na1.omnichannel.dev.internal"
  orchestration-port                     = 443
  orchestration-request-timeout-ms       = 500
  orchestration-requests-enabled         = true
  orchestration-ssl-verification-enabled = false
  environment                            = "ic-dev"
  test-bus                               = "-33" // test bus that will skip be migrationto flink state as they are heartbeat events
}

module "state-streams-mixed-dfo-contact" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version = "0.12.7" // Version of the Terraform module to deploy

  app-version                              = "development" // Name of the branch or tag to deploy
  app-version-type                         = "branch"      // Either "branch" or "tag"
  log-level                                = "DEBUG"
  flink-runtime                            = "FLINK-1_20"
  use-flink-state                          = false
  enable-dynamodb-to-flink-state-migration = false

  transformer                                         = "mixed-dfo-contact"        // Name of the State Streams transformer to instantiate
  input-source                                        = "kinesis"                  // Either "kafka" or "kinesis"
  kinesis-stream-names                                = "do-de-case-events-stream" // All the stream names that the flink app will subscribe to
  kinesis-initial-position-offset-from-latest-seconds = 3600
  deploy-test-kinesis-stream                          = true
  efo-registration-type                               = "lazy"
  kafka-output-topic                                  = "SuiteData.MixedContactEvent.V2"
  kafka-test-output-topic                             = "SuiteData.IntegrationTests.MixedContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = false

  snapshots-enabled         = true
  application-owner         = "ESC / esc@niceincontact.com"
  region                    = "us-west-2"
  environment-prefix        = "do"
  security-groups           = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                   = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket = "do-entitymanagement"
  parallelism               = 4
  parallelism-per-kpu       = 4
  auto-scaling-enabled      = false

  orchestration-host                     = "entitymanagement-griffin-ss-vpce-na1.omnichannel.dev.internal"
  orchestration-port                     = 443
  orchestration-request-timeout-ms       = 500
  orchestration-requests-enabled         = false
  orchestration-ssl-verification-enabled = false
  environment                            = "ic-dev"
  test-bus                               = "-33" // test bus that will skip be migrationto flink state as they are heartbeat events
}

module "state-streams-dfo-agent-contact" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version = "0.12.7" // Version of the Terraform module to deploy on spacelift

  app-version      = "development"
  app-version-type = "branch"
  log-level        = "DEBUG"
  flink-runtime    = "FLINK-1_20"

  transformer                = "dfo-agent-contact"                                                       // Name of the State Streams transformer to instantiate
  input-source               = "kinesis"                                                                 // Either "kafka" or "kinesis"
  kinesis-stream-names       = "dev-agent-session,do-de-platform-events-stream,do-de-case-events-stream" // All the stream names that the flink app will subscribe to
  deploy-test-kinesis-stream = true
  efo-registration-type      = "lazy"
  kafka-output-topic         = "SuiteData.AgentContactEvent.V2"
  kafka-test-output-topic    = "SuiteData.IntegrationTests.AgentContactEvent.V1"

  dynamodb-table-name = "state-streams-state"

  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  schema-registry-ssl-verification-enabled = false

  snapshots-enabled         = false
  application-owner         = "ESC / esc@niceincontact.com"
  region                    = "us-west-2"
  environment-prefix        = "do"
  security-groups           = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                   = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket = "do-entitymanagement"
  parallelism               = 4
  parallelism-per-kpu       = 4
  auto-scaling-enabled      = false

  orchestration-host                                  = "entitymanagement-griffin-ss-vpce-na1.omnichannel.dev.internal"
  orchestration-port                                  = 443
  orchestration-request-timeout-ms                    = 500
  orchestration-requests-enabled                      = true
  orchestration-ssl-verification-enabled              = false
  environment                                         = "ic-dev"
  test-bus                                            = "-33" // test bus that will skip be migrationto flink state as they are heartbeat events
  kinesis-initial-position-offset-from-latest-seconds = 3600
}

module "state-streams-infra" {
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-infra-development/default"
  version = "0.9.25" //Version of the Terraform module to deploy

  region                               = "us-west-2"
  environment-prefix                   = "do"
  subnets                              = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"]
  load-test-kinesis-stream-shard-count = 12
}

module "state-streams-multi-event-agent" {
  // Note that changing between "orch-entity-state-streams" and "orch-entity-state-streams-development" causes the app to be recreated
  source            = "spacelift.io/incontact/orch-entity-state-streams-terraform-multi-event-development/default"
  version           = "0.0.34" // Version of the Terraform module to deploy
  application-owner = "ESC / esc@niceincontact.com"

  app-version        = "development" // Name of the branch or tag to deploy
  app-version-type   = "branch"      // Either "branch" or "tag"
  log-level          = "DEBUG"
  flink-runtime      = "FLINK-1_20"
  transformer        = "em-multi-event-agent" // Name of the State Streams transformer to use
  input-source       = "kafka"                // Either "kafka" or "kinesis"
  kafka-input-topics = "EntityManagement.Agent.AgentEvent.V2,EntityManagement.Unicorn.Agent.AgentEvent.V2,EntityManagement.Kraken.Agent.AgentEvent.V2,EntityManagement.Griffin.Agent.AgentEvent.V2,EntityManagement.Werewolf.Agent.AgentEvent.V2,EntityManagement.Trojanhorse.Agent.AgentEvent.V2,EntityManagement.Phoenix.Agent.AgentEvent.V2,EntityManagement.Yeti.Agent.AgentEvent.V2"
  # kafka-input-topics = "SuiteData.LoadTests.LoadTestInput.V2"
  kafka-output-topic = "SuiteData.AgentSessionEvent.V2"
  # kafka-output-topic = "SuiteData.LoadTests.LoadTestOutput.V2"
  kafka-side-output-topic = "SuiteData.AgentContactEvent.V2"
  # kafka-side-output-topic               = "SuiteData.LoadTests.LoadTestOutput.V2"
  kafka-test-output-topic               = "SuiteData.IntegrationTests.AgentSessionEvent.V2"
  kafka-input-test-topic                = "SuiteData.IntegrationTests.AgentEventEMHeartbeat.V2"
  deploy-test-kinesis-stream            = false
  schema-registry-url                   = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                  = false
  schema-registry-auto-register-schemas = false
  transformer_name_for_state            = "dfo-agent-contact"
  state-request-capacity                = 1000

  snapshots-enabled                        = false
  region                                   = "us-west-2"
  environment-prefix                       = "do"
  security-groups                          = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                                  = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket                = "do-entitymanagement"
  parallelism                              = 4
  parallelism-per-kpu                      = 4
  auto-scaling-enabled                     = false
  schema-registry-ssl-cert-s3-bucket-name  = "ic-certs-do"
  schema-registry-ssl-ca-cert              = "star.omnichannel.dev.internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert          = "star.omnichannel.dev.internal/star.omnichannel.dev.internal.cer"
  schema-registry-ssl-verification-enabled = false
  environment                              = "ic-dev"

  # The Multi-event module doesn't support "sources" yet.
  # sources = [
  #   {
  #     name        = "AgentEventV2"
  #     type        = "kafka"
  #     topic       = "EntityManagement.Agent.AgentEvent.V2"
  #     inputType   = "standard"
  #     parallelism = 1
  #   },
  #   {
  #     name        = "heartbeat"
  #     type        = "kafka"
  #     topic       = "SuiteData.IntegrationTests.AgentEventEMHeartbeat.V2"
  #     inputType   = "test"
  #     parallelism = 1
  #   }
  # ]
}

module "state-streams-em-contactV2" {
  // Note that changing between "orch-entity-state-streams" and "orch-entity-state-streams-development" causes the app to be recreated
  source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
  version = "0.12.7" // Version of the Terraform module to deploy

  app-version                              = "development" // Name of the branch or tag to deploy
  app-version-type                         = "branch"      // Either "branch" or "tag"
  log-level                                = "DEBUG"
  flink-runtime                            = "FLINK-1_20"
  transformer                              = "em-contact-v2" // Name of the State Streams transformer to instantiate
  input-source                             = "kafka"         // Either "kafka" or "kinesis"
  kafka-input-topics                       = "EntityManagement.Unicorn.Contact.ContactEvent.V2,EntityManagement.Contact.ContactEvent.V2,EntityManagement.Griffin.Contact.ContactEvent.V2,EntityManagement.Hydra.Contact.ContactEvent.V2,EntityManagement.Kraken.Contact.ContactEvent.V2,EntityManagement.Phoenix.Contact.ContactEvent.V2,EntityManagement.Trojanhorse.Contact.ContactEvent.V2,EntityManagement.Yeti.Contact.ContactEvent.V2,EntityManagement.Werewolf.Contact.ContactEvent.V2"
  kafka-output-topic                       = "SuiteData.ContactEvent.V2"
  kafka-test-output-topic                  = "SuiteData.IntegrationTests.ContactEvent.V2"
  kafka-input-test-topic                   = "SuiteData.IntegrationTests.ContactEventEMHeartbeat.V2"
  deploy-test-kinesis-stream               = false
  schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
  schema-registry-mock                     = false
  schema-registry-auto-register-schemas    = false
  dynamodb-table-name                      = "state-streams-state"
  snapshots-enabled                        = false
  region                                   = "us-west-2"
  environment-prefix                       = "do"
  security-groups                          = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
  subnets                                  = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
  build-artifacts-s3-bucket                = "do-entitymanagement"
  parallelism                              = 4
  parallelism-per-kpu                      = 4
  auto-scaling-enabled                     = false
  schema-registry-ssl-cert-s3-bucket-name  = "ic-certs-do"
  schema-registry-ssl-ca-cert              = "star.omnichannel.dev.internal/in-ena-incer01-ca.cer"
  schema-registry-ssl-server-cert          = "star.omnichannel.dev.internal/star.omnichannel.dev.internal.cer"
  schema-registry-ssl-verification-enabled = false
  transformer_name_for_state               = "dfo-contact"
  environment                              = "ic-dev"
  test-bus                                 = "-33" // test bus that will skip be migrationto flink state as they are heartbeat events
}

# module "state-streams-mixed-dfo-contact-loadtesting" {
#   source  = "spacelift.io/incontact/orch-entity-state-streams-terraform-state-streams-development/default"
#   version = "0.12.7" // Version of the Terraform module to deploy
#
#   name-suffix = "-loadtesting"
#
#   app-version                              = "development" // Name of the branch or tag to deploy
#   app-version-type                         = "branch"      // Either "branch" or "tag"
#   log-level                                = "INFO"
#   flink-runtime                            = "FLINK-1_20"
#   use-flink-state                          = true
#   enable-dynamodb-to-flink-state-migration = true
#
#   transformer  = "mixed-dfo-contact" // Name of the State Streams transformer to instantiate
#   input-source = "kinesis"           // This will be ignored because sources is set
#   sources = [
#     {
#       name        = "legacy kinesis 0"
#       type        = "kinesis"
#       topic       = "state-streams-load-test"
#       inputType   = "standard"
#       parallelism = 6 // Stream has 12 shards
#     },
#     {
#       name        = "legacy kinesis 1"
#       type        = "kinesis"
#       topic       = "state-streams-mixed-dfo-contact-loadtesting-test-stream"
#       inputType   = "test"
#       parallelism = 1 // Stream has 1 shard
#     }
#   ]
#   kinesis-initial-position-offset-from-latest-seconds = 0
#   deploy-test-kinesis-stream                          = true
#   efo-registration-type                               = "lazy"
#   kafka-output-topic                                  = "SuiteData.LoadTests.LoadTestOutput.V2"
#   kafka-test-output-topic                             = "SuiteData.IntegrationTests.MixedContactEvent.V1"
#
#   dynamodb-table-name = "state-streams-state"
#
#   schema-registry-url                      = "https://schema-registry-ss-vpce-na1.omnichannel.dev.internal/schema-registry"
#   schema-registry-mock                     = false
#   schema-registry-auto-register-schemas    = false
#   schema-registry-ssl-verification-enabled = false
#
#   snapshots-enabled         = true
#   application-owner         = "ESC / esc@niceincontact.com"
#   region                    = "us-west-2"
#   environment-prefix        = "do"
#   security-groups           = ["sg-09a965af97dfdbd22"]                                                             // Broker Service security group
#   subnets                   = ["subnet-0561d524f79f6cbc9", "subnet-0825bab568ce5b7f4", "subnet-08421b279b2e7358d"] // Broker Service subnets
#   build-artifacts-s3-bucket = "do-entitymanagement"
#   parallelism               = 16
#   parallelism-per-kpu       = 4
#   auto-scaling-enabled      = true
#
#   orchestration-host                     = "entitymanagement-griffin-ss-vpce-na1.omnichannel.dev.internal"
#   orchestration-port                     = 443
#   orchestration-request-timeout-ms       = 500
#   orchestration-requests-enabled         = false
#   orchestration-ssl-verification-enabled = false
#   environment                            = "ic-dev"
# }
