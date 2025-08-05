resource "google_artifact_registry_repository" "default" {
  project       = var.google_cloud_k8s_project
  location      = var.google_cloud_default_region
  repository_id = "default-repository"
  description   = "Repository for Docker images"
  format        = "DOCKER"
}
