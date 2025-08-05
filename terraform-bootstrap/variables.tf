variable "google_cloud_project" {
  description = "The Google Cloud Project ID that holds bootstrap resources"
  type        = string
}

variable "google_cloud_default_region" {
  description = "The default region to use when no other is set"
  default     = "us-central1"
  type        = string
}
