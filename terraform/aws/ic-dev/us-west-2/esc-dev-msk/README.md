# esc-dev-msk

This folder contains code to deploy a MSK cluster in AWS. This is a backup cluster for the dev environment.
This cluster is deployed in the us-west-2 region. And can be used by the ESC microservices in the dev environment.

The module present in main.tf if uncommented and pushed to main will create a MSK cluster that can be used by our ESC microservices
First deploy the module with public access as false and then update the module with public access as true

