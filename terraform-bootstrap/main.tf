
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_project_service" "default" {
  project            = var.google_cloud_project
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}

resource "google_storage_bucket" "default" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  force_destroy = true
  location      = "US"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

output "storage_bucket" {
  value = google_storage_bucket.default.name
}

locals {
  service_list = [
    "storage.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "aiplatform.googleapis.com",
  ]
}

resource "google_project_service" "service" {
  for_each = toset(local.service_list)
  project  = var.google_cloud_project
  service  = each.key
  # Destroying this resource will not disable the APIs. This in case the APIs
  # are in-use otherwise.
  disable_on_destroy = false
}
