resource "google_service_account" "default" {
  count        = var.create_bastion ? 1 : 0
  project      = var.google_cloud_k8s_project
  account_id   = "custom-compute-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  count        = var.create_bastion ? 1 : 0
  project      = var.google_cloud_k8s_project
  name         = "bastion"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = "100"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network            = local.network_name
    subnetwork         = local.subnet_name
    subnetwork_project = var.google_cloud_k8s_project

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
    startup-script = <<-EOF
  sudo apt install postgresql-client -y
  sudo apt install dnsutils -y
  EOF
  }

  service_account {
    email  = google_service_account.default[count.index].email
    scopes = ["cloud-platform"]
  }

  depends_on = [module.gcp_network]
}
