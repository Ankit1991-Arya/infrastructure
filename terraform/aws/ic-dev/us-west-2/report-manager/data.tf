data "aws_kms_key" "sqs_kms_key" {
  key_id = "alias/aws/sqs"
}
