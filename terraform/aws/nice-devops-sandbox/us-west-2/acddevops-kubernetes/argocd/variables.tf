variable "ARGOCD_DEX_CLIENT_SECRET" {
  description = "A github client secret, see: https://argo-cd.readthedocs.io/en/release-1.8/operator-manual/user-management/#dex"
  sensitive   = true
  type        = string
}

variable "ARGOCD_GITHUB_WEBHOOK_SECRET" {
  description = "A secret which is used in the github webhook events sent to ArgoCD from GitHub."
  sensitive   = true
  type        = string
}

variable "ARGOCD_GITHUB_APP_PRIVATE_KEY" {
  description = "A private key for a github app which will be used to authenticate ArgoCD to GitHub to access repository contents."
  sensitive   = true
  type        = string
}

variable "ARGOCD_NOTIFICATIONS_GITHUB_APP_PRIVATE_KEY" {
  description = "A private key for ArgoCD to GitHub notifications"
  sensitive   = true
  type        = string
}

variable "MSTEAMS_WEBHOOK_NICE_INCONTACT_KUBERNETES_ARGOCD_NOTIFICATIONS" {
  description = "A MS Team webhook for NICE INCONTACT"
  sensitive   = true
  type        = string
}

variable "PAT_NICECXONE_ARGOCD_NOTIFICATIONS_GITHUB_USER" {
  description = "A Github user PAT"
  sensitive   = true
  type        = string
}