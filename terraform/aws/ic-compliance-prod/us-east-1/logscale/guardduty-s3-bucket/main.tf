resource "aws_guardduty_publishing_destination" "guardduty_publishing_destination" {
  count           = (var.guard_duty_enabled == true && var.guard_duty_s3_bucket_enabled == true) ? 1 : 0
  detector_id     = var.guardduty_detector_id
  destination_arn = module.s3_guardduty_bucket[0].s3_bucket_arn
  kms_key_arn     = aws_kms_key.guardduty_s3_kms_key[0].arn

  depends_on = [
    module.s3_guardduty_bucket,
    aws_s3_bucket_policy.guardduty_bucket_policy,
    aws_kms_key.guardduty_s3_kms_key
  ]
}