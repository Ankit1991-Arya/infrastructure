variable "ecr_image" {
  description = "The ECR image repository for the Lambda function."
  type        = string
  default     = "300813158921.dkr.ecr.us-west-2.amazonaws.com/routing-ng/routing-ng-fmsafe"
}

variable "image_tag" {
  description = "The image tag for the ECR image."
  type        = string
  default     = "02684172f110f308a928b3553508d634bd41c150-develop"
}
variable "kinesis_stream" {
  description = "The stream that triggers lambda."
  type        = string
  default     = "dev-findmatch-matchrequests"
}

variable "rds_subnetgroup" {
  description = "AFM service RDS instance is created in subnet group"
  type        = string
  default     = "afm-routing-subnet-group"
}

variable "afm_sg" {
  description = "Security Group ID where the RDS instance is created"
  type        = string
  default     = "sg-0cf39f9e0eb221b33"
}

variable "create_current_version_allowed_triggers" {
  description = "A boolean flag to indicate if current version allowed triggers should be created."
  type        = bool
  default     = false
}

variable "create_package" {
  description = "A boolean flag to determine if the package should be created."
  type        = bool
  default     = false
}

variable "create_role" {
  description = "A boolean flag to determine if the IAM role for the Lambda function should be created."
  type        = bool
  default     = false
}

variable "description" {
  description = "A description of the Lambda function."
  type        = string
  default     = "lambda that gets triggered from kinesis streams findmatch-matchrequests Kinesis stream and put messages into SQS so that Vc can read it."
}

variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
  default     = "routing-ng-fmsafe-routinghandler"
}

variable "package_type" {
  description = "The deployment package type. Set to 'Image' for container images."
  type        = string
  default     = "Image"
}

variable "role_name" {
  description = "The name of the IAM role for the Lambda function."
  type        = string
  default     = "ServiceAccess-routing-routing-ng-fmsafe"
}

variable "timeout" {
  type    = number
  default = 30
}
