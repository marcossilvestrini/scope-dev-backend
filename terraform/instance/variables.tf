variable "mgc_api_key" {
  type        = string
  description = "API key for authentication."
  sensitive   = false
}

variable "mgc_obj_key_id" {
  type        = string
  description = "Key ID to access the Object Storage product."
  sensitive   = false
}

variable "mgc_obj_key_secret" {
  type        = string
  description = "Secret of the key to access the Object Storage product."
  sensitive   = false
}
