# Nexpose Scan Engine

# Terraform Configuration: Using AWS VPC Endpoint Module

## Overview

This Terraform configuration demonstrates how to use the `private-link-vpc-endpoint` module from [aws-terraform-modules-network](https://github.com/inContact/aws-terraform-modules-network/tree/main/modules/aws_privatelink_vpc_endpoint) repository and published in [Spacelift Terraform registry](https://incontact.app.spacelift.io/module/private-link-vpc-endpoint) to create an AWS VPC Endpoint for Private Link and associated Route 53 records.

## Usage

For ease of use, we have separate module call (written in main.tf) from the actual inputs (inputs.yaml) you need to provide for the module call.
For easy readability, we will be maintaining the inputs in yaml format. You just need to add new block under `private_link_data`.

Here are few examples for the same:

**Example1** (With security group ids and route53 record)
```yaml
private_link_data:
  test-vpc-endpoint:
    vpc_id: vpc-123
    subnet_ids:
      - subnet-1
      - subnet-2
    security_group_ids:
        - security-group-1
        - security-group-2
    service_name: "com.amazonaws.vpce.us-west-2.vpce-svc-1"
    route53_record: "private-link-test.abc.xyz"
    tags: 
      Ticket: "CNC-3977"
      Owner: "API_fascade"
      InfrastructureOwner: "network_team"
      Product: "API-fascade"
```

**Example2** (Without security group ids and route53 record)
```yaml
private_link_data:
  test-vpc-endpoint:
    vpc_id: vpc-123
    subnet_ids:
      - subnet-1
      - subnet-2
    security_group_ids: []
    service_name: "com.amazonaws.vpce.us-west-2.vpce-svc-1"
    route53_record: ""
    tags:
      Ticket: "CNC-3977"
      Owner: "API_fascade"
      InfrastructureOwner: "network_team"
      Product: "API-fascade"
```

### Inputs in inputs.yaml

- `vpc_id` (Required): The ID of the VPC where the endpoint will be created.
- `subnet_ids` (Reuired): The ID of one or more subnets in which to create a network interface for the endpoint.
- `security_group_ids` (Optional): The ID of one or more security groups to associate with the network interface. If no security groups are specified, the VPC's default security group is associated with the endpoint. And you need to mention empty array like: `[]` in code.
- `service_name` (Required): The name of the AWS service for which the endpoint will be created.
- `vpc_endpoint_type` (Optional): The VPC endpoint type, `Gateway`, `GatewayLoadBalancer`, or `Interface`. Defaults to `Interface`.
- `private_dns_enabled` (Optional): Whether or not to associate a private hosted zone with the specified VPC. Most users will want this enabled to allow services within the VPC to automatically use the endpoint. Defaults to `false`
- `route53_record` (Optional): The name of the DNS record to be created in Route 53. If you don't want to create route53 record, you may need to mention empty string like: `""`.
