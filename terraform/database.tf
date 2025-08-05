
resource "random_password" "default" {
  length = 16
}

resource "google_sql_database_instance" "default" {
  project          = var.google_cloud_db_project
  database_version = "POSTGRES_15"
  name             = "toys-inventory"
  region           = var.google_cloud_default_region
  root_password    = random_password.default.result
  settings {
    edition           = "ENTERPRISE_PLUS"
    tier              = "db-perf-optimized-N-8" # 8 vCPU, 64GB RAM
    availability_type = "REGIONAL"
    disk_size         = 250
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
    ip_configuration {
      ssl_mode = "ENCRYPTED_ONLY"
      psc_config {
        psc_enabled = true
        allowed_consumer_projects = [
          var.google_cloud_k8s_project
        ]
      }
      ipv4_enabled = false
    }
    data_cache_config {
      data_cache_enabled = true
    }
  }
  # Note: in production environments, this setting should be true to prevent
  # accidental deletion. Set it to false to make tf apply and destroy work
  # quickly.
  deletion_protection = false
}

resource "google_sql_user" "iam_sa_user" {
  name     = local.iam_sa_username
  instance = google_sql_database_instance.default.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
  project  = var.google_cloud_db_project
}

resource "google_sql_database" "default" {
  name     = "retail"
  instance = google_sql_database_instance.default.name
  project  = var.google_cloud_db_project
}
