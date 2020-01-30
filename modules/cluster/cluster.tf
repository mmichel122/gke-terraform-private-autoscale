resource "google_container_cluster" "primary" {
  project            = var.project_id
  name               = var.cluster_name
  location           = var.location
  network            = var.network_name
  subnetwork         = var.subnetwork_name
  min_master_version = var.min_master_version 

  vertical_pod_autoscaling {
    enabled = true
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.secondary_ip_range_pods
    services_secondary_range_name = var.secondary_ip_range_services
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.16.0.16/28"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "system_nodes" {
  project    = var.project_id
  name       = "system-nodes"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.system_nodes_size
    disk_type    = "pd-standard"
    service_account = var.system_service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    tags            = ["kubernetes-system"]
    labels = {
      pool-type = "system"
    }
  }
}

resource "google_container_node_pool" "worker_nodes" {
  project    = var.project_id
  name       = "worker-nodes"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 0

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.autoscale_min_nodes
    max_node_count = var.autoscale_max_nodes
  }

  node_config {
    machine_type = var.worker_nodes_size
    disk_type    = "pd-standard"
    service_account = var.worker_service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    tags            = ["kubernetes-worker"]
    labels = {
      pool-type = "worker"
    }
    taint {
      key = "scripts"
      value = "true"
      effect = "NO_SCHEDULE"
    }
  }
}