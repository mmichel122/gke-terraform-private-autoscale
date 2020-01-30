module "network" {
  source                      = "./modules/network"
  project_id                  = var.project_id
  network_name                = var.network_name
  region                      = var.region
  ip_range_nodes              = var.ip_range_nodes
  secondary_ip_range_pods     = var.secondary_ip_range_pods
  secondary_ip_range_services = var.secondary_ip_range_services
  subnets_count               = var.subnets_count
}

module "cluster" {
  source                      = "./modules/cluster"
  project_id                  = var.project_id
  cluster_name                = var.cluster_name
  location                    = var.location
  network_name                = module.network.network_name
  subnetwork_name             = module.network.subnetwork_name
  min_master_version          = var.min_master_version
  system_nodes_size           = var.system_nodes_size
  worker_nodes_size           = var.worker_nodes_size
  autoscale_min_nodes         = var.autoscale_min_nodes
  autoscale_max_nodes         = var.autoscale_max_nodes
  secondary_ip_range_pods     = module.network.secondary_ip_range_pods
  secondary_ip_range_services = module.network.secondary_ip_range_services
  system_service_account      = module.service_account.email
  worker_service_account      = var.worker_service_account
}

module "service_account" {
  source       = "./modules/service_account"
  project_id   = var.project_id
  cluster_name = var.cluster_name
}