data "aws_iam_policy_document" "guardduty_topic" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:s3-guardduty-event-notifications"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:s3:::${local.ls_guardduty_name}"]
    }
  }
}

#tfsec:ignore:aws-sns-topic-encryption-use-cmk
#tfsec:ignore:aws-sns-enable-topic-encryption
resource "aws_sns_topic" "guardduty-topic" {
  name   = "s3-guardduty-event-notifications"
  policy = data.aws_iam_policy_document.guardduty_topic.json
}

resource "aws_s3_bucket_notification" "guardduty-notification" {
  bucket = local.ls_guardduty_name

  topic {
    events    = ["s3:ObjectCreated:Put"]
    topic_arn = aws_sns_topic.guardduty-topic.arn
  }
}