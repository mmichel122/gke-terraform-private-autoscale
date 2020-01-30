resource "google_compute_network" "gke_network" {
  project                 = var.project_id
  name                    = var.network_name
  description             = "The VPC that hosts the GKE cluster."
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "europe" {
  project                  = var.project_id
  name                     = "gke-subnet"
  count                    = var.subnets_count
  ip_cidr_range            = cidrsubnet(var.ip_range_nodes, 8, count.index + 1)
  region                   = var.region
  network                  = google_compute_network.gke_network.self_link
  private_ip_google_access = true

  secondary_ip_range { 
    range_name    = "pods-subnet" 
    ip_cidr_range = cidrsubnet(var.secondary_ip_range_pods, 8, count.index + 1)
  }

  secondary_ip_range { 
    range_name    = "services-subnet" 
    ip_cidr_range = cidrsubnet(var.secondary_ip_range_services, 8, count.index + 1)
  }
}