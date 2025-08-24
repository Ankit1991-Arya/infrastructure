terraform {
  required_version = "1.3.1"
}

module "spacelift_msteams" {
  source = "spacelift-io/msteams/spacelift"

  version      = "0.1.1"
  channel_name = var.channels_name
  space_id     = "legacy"
  webhook_url  = var.webhook_url
}

variable "webhook_url" {
  type        = string
  description = "webhook url to ms teams"
  default     = "https://niceonline.webhook.office.com/webhookb2/e6bd78fe-eba5-4969-84b2-376ea74a8752@7123dabd-0e87-4da9-9cb9-b7ec82011aad/IncomingWebhook/85408bb54eae4edd8b86cc964bb4dc18/8eb5eb11-f047-4b2e-a547-ec4e47d2f987"
}

variable "channels_name" {
  type        = string
  description = "MS teams channel name"
  default     = "cnc-spacelift-notification"
}