resource "google_compute_network" "vpc" {
  name                            = "${local.prefix}-vpc"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true

  depends_on = [google_project_service.api]
}

resource "google_compute_route" "default_route" {
  name             = "${local.prefix}-default-route"
  network          = google_compute_network.vpc.name
  next_hop_gateway = "default-internet-gateway"
  dest_range       = "0.0.0.0/0"
}
