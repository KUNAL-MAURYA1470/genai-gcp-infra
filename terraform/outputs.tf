output "psc_dns_name" {
  value = google_sql_database_instance.default.dns_name
}

output "cloud_sql_root_password" {
  value     = random_password.default.result
  sensitive = true
}

output "application_workload_identity" {
  value = module.workload_identity.gcp_service_account_email
}
