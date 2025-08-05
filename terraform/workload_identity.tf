module "workload_identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version    = "37.1.0"
  name       = "app-sa"
  namespace  = "default"
  project_id = var.google_cloud_k8s_project
  roles = [
    "roles/aiplatform.user",
  ]
}

resource "google_project_iam_member" "database_access" {
  project = var.google_cloud_db_project
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${module.workload_identity.gcp_service_account_email}"
}
