variable "spacelift_token" {
  description = "The Spacelift token retrieved from the worker pool creation step once the TLS CSR gets uploaded"
  type        = string
}

variable "spacelift_api_key_id" {
  type        = string
  description = "The ID of the API key to use for authenticating with the Spacelift API"
}

variable "spacelift_api_key_secret" {
  description = "The secret of the API key to use for authenticating with the Spacelift API"
  type        = string
}

variable "worker_pool_id" {
  type        = string
  description = "The ID of the worker pool that was previously created in Spacelift"
}

variable "worker_pool_private_key" {
  type        = string
  description = "The private TLS key used to sign the CSR uploaded to Spacelift while creating the worker pool"
}
