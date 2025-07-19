resource "google_container_cluster" "gke" {
  name                     = "${local.prefix}-gke-cluster"
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  networking_mode          = "VPC_NATIVE"

  deletion_protection = false

  # Optional, if you want multi-zonal cluster
  # node_locations = ["us-central1-b"]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pods"
    services_secondary_range_name = "k8s-services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "192.168.0.0/28"
  }

}

# This service account will be used by the GKE cluster to access Google Cloud resources
resource "google_service_account" "bucket-reader" {
  account_id   = "${local.prefix}-bucket-reader"
  display_name = "Bucket Reader Service Account"
}

resource "kubernetes_service_account" "bucket-reader" {
  metadata {
    name      = "bucket-reader"
    namespace = "default"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.bucket-reader.email
    }
  }
}

resource "google_project_iam_member" "bucket-reader-storage-object-viewer" {
  project = local.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.bucket-reader.email}"
}

resource "google_service_account_iam_binding" "bucket-reader-binding" {
  service_account_id = google_service_account.bucket-reader.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${local.project_id}.svc.id.goog[default/bucket-reader]"]
}
