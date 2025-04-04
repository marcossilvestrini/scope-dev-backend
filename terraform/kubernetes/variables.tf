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

variable "backend_bucket" {
  type        = string
  description = "Defines the bucket for backend storage"
  default     = "br-se1-backend-tfstate"
}

variable "mgc_env" {
  type        = string
  description = "Defines the operating environment"
  default     = "prod"
}

variable "mgc_region" {
  type        = string
  description = "Specifies the region where resources will be created and managed."
  default     = "br-se1"
}

variable "k8s_version" {
  type    = string
  default = "v1.30.2"
}

variable "name" {
  type        = string
  description = "Kubernetes cluster name. Must be unique within a namespace and follow naming rules."
  default     = "backstage-cluster-01"

}

variable "description" {
  type        = string
  description = "A brief description of the Kubernetes cluster."
  default     = "Cluster Kubernetes MGC"
}

variable "enabled_server_group" {
  type        = bool
  description = "Enables the use of a server group with anti-affinity policy during the creation of the cluster and its node poo"
  default     = false
}

variable "async_creation" {
  type        = bool
  description = "Enables asynchronous creation of the Kubernetes cluster."
  default     = false
}

variable "allowed_cidrs" {
  type = list(string)
  default = [
    "192.168.0.1/32",
    "172.16.0.1/32",
  ]
}
