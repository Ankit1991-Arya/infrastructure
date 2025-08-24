terraform {
  required_version = ">= 1.3.7"
  required_providers {
    kafka = {
      source  = "spacelift.io/inContact/kafka"
      version = "0.7.8"
    }
  }
}
provider "kafka" {
  bootstrap_servers = local.bootstrap_servers
  tls_enabled       = true
  sasl_iam_enabled  = true
}

locals {
  bootstrap_servers = [
    "b-3-public.publicmsk01uswest2.zm5tbk.c7.kafka.us-west-2.amazonaws.com:9198",
    "b-2-public.publicmsk01uswest2.zm5tbk.c7.kafka.us-west-2.amazonaws.com:9198",
    "b-1-public.publicmsk01uswest2.zm5tbk.c7.kafka.us-west-2.amazonaws.com:9198"
  ]

  acl_groups       = fileexists("./acl_groups.yaml") ? yamldecode(file("./acl_groups.yaml")) : []
  acl_topics       = fileexists("./acl_topics.yaml") ? yamldecode(file("./acl_topics.yaml")) : []
  acl_clusters     = fileexists("./acl_clusters.yaml") ? yamldecode(file("./acl_clusters.yaml")) : []
  acl_transactions = fileexists("./acl_transactions.yaml") ? yamldecode(file("./acl_transactions.yaml")) : []
  acl_unknowns     = fileexists("./acl_unknowns.yaml") ? yamldecode(file("./acl_unknowns.yaml")) : []
  acl_any          = fileexists("./acl_any.yaml") ? yamldecode(file("./acl_any.yaml")) : []

  acl_group_entries = flatten([
    for group in local.acl_groups : [
      for operation in group.operations : {
        resource_name         = group.resource_name
        resource_pattern_type = group.resource_pattern_type
        principal             = group.principal
        host                  = group.host
        operation             = operation
        permission_type       = group.permission_type
      }
    ]
  ])

  acl_topic_entries = flatten([
    for topic in local.acl_topics : [
      for operation in topic.operations : {
        resource_name         = topic.resource_name
        resource_pattern_type = topic.resource_pattern_type
        principal             = topic.principal
        host                  = topic.host
        operation             = operation
        permission_type       = topic.permission_type
      }
    ]
  ])

  acl_cluster_entries = flatten([
    for cluster in local.acl_clusters : [
      for operation in cluster.operations : {
        resource_name         = cluster.resource_name
        resource_pattern_type = cluster.resource_pattern_type
        principal             = cluster.principal
        host                  = cluster.host
        operation             = operation
        permission_type       = cluster.permission_type
      }
    ]
  ])

  acl_transaction_entries = flatten([
    for transaction in local.acl_transactions : [
      for operation in transaction.operations : {
        resource_name         = transaction.resource_name
        resource_pattern_type = transaction.resource_pattern_type
        principal             = transaction.principal
        host                  = transaction.host
        operation             = operation
        permission_type       = transaction.permission_type
      }
    ]
  ])

  acl_unknown_entries = flatten([
    for unknown in local.acl_unknowns : [
      for operation in unknown.operations : {
        resource_name         = unknown.resource_name
        resource_pattern_type = unknown.resource_pattern_type
        principal             = unknown.principal
        host                  = unknown.host
        operation             = operation
        permission_type       = unknown.permission_type
      }
    ]
  ])

  acl_any_entries = flatten([
    for any in local.acl_any : [
      for operation in any.operations : {
        resource_name         = any.resource_name
        resource_pattern_type = any.resource_pattern_type
        principal             = any.principal
        host                  = any.host
        operation             = operation
        permission_type       = any.permission_type
      }
    ]
  ])
}

module "msk-config" {
  source = "github.com/inContact/terraform-modules-msk.git//modules/public-msk/msk-config?ref=CNC-4904-public-msk-module"
  # source  = "spacelift.io/incontact/msk-config/default"
  # version = "0.1.24"
  acl_groups       = local.acl_group_entries
  acl_topics       = local.acl_topic_entries
  acl_clusters     = local.acl_cluster_entries
  acl_transactions = local.acl_transaction_entries
  acl_unknowns     = local.acl_unknown_entries
  acl_any          = local.acl_any_entries
}
