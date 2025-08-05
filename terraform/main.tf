locals {
  network_name        = "production-network"
  subnet_name         = "k8s-subnet"
  gke_pods_range_name = "gke-pods-autopilot-private"
  gke_svc_range_name  = "gke-svc-autopilot-private"

  subnet_names = [
    for subnet_self_link in module.gcp_network.subnets_self_links :
    split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]
  ]

  iam_sa_username = trimsuffix(
    module.workload_identity.gcp_service_account_email,
    ".gserviceaccount.com",
  )
}
