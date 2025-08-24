resource "aws_kms_key" "kms_encryption" {
  description         = "An kinesis KMS key"
  enable_key_rotation = var.lambda_config.data.KMS.enable_key_rotation
}

resource "aws_kinesis_stream" "uptime_kinesis" {
  name             = "uptime-data-points-stream"
  shard_count      =  var.lambda_config.data.kinesis.shard_count
  retention_period =  var.lambda_config.data.kinesis.retention_period
  encryption_type  =  var.lambda_config.data.kinesis.encryption_type
  kms_key_id       = aws_kms_key.kms_encryption.arn
}

resource "aws_lambda_event_source_mapping" "kinesis_lambda_mapping" {
  event_source_arn  = aws_kinesis_stream.uptime_kinesis.arn
  function_name     = var.lambda_arn
  starting_position = "LATEST"
}

output "kinesis_data_stream_output" {
  value       = aws_kinesis_stream.uptime_kinesis.arn
  description = "Kinesis data stream with shards"
}