module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version = "37.1.0"
  name       = "prod-toy-store-semantic-search"
  project_id = var.google_cloud_k8s_project
  region     = var.google_cloud_default_region
  network    = module.gcp_network.network_name
  subnetwork = local.subnet_names[
    index(module.gcp_network.subnets_names, local.subnet_name)
  ]
  master_ipv4_cidr_block = "172.16.0.0/28"
  ip_range_pods          = local.gke_pods_range_name
  ip_range_services      = local.gke_svc_range_name
  enable_private_nodes   = true
  grant_registry_access  = true

  # Setting this to false makes it easy to deploy and tear down the cluster.
  # For production deployments, you'll want to set this to true.
  deletion_protection = false
}

resource "kubernetes_secret" "db_admin" {
  metadata {
    name = "db-admin"
  }

  data = {
    username = "postgres"
    password = random_password.default.result
  }
}

resource "kubernetes_secret" "db_iam_connection_info" {
  metadata {
    name = "db-iam-connection-info"
  }

  data = {
    host     = google_sql_database_instance.default.dns_name
    username = local.iam_sa_username
    dbname   = google_sql_database.default.name
  }
}

resource "kubernetes_secret" "project_metadata" {
  metadata {
    name = "project-metadata"
  }

  data = {
    projectid = var.google_cloud_k8s_project
    region    = var.google_cloud_default_region
  }
}
