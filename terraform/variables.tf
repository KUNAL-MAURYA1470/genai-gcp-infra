variable "google_cloud_db_project" {
  description = "Google Cloud Project for the Cloud SQL instance"
  type        = string
}

variable "google_cloud_k8s_project" {
  description = "Google Cloud Project for the K8s cluster"
  type        = string
}

variable "google_cloud_default_region" {
  description = "The default region to use when no other is set"
  default     = "us-central1"
  type        = string
}

variable "create_bastion" {
  description = "Creation a Bastion instance for debugging"
  default     = false
}
