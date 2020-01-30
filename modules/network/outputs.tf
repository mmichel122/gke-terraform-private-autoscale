output "network_name" {
  value = "${google_compute_network.gke_network.name}"
}

output "subnetwork_name" {
  value = "${google_compute_subnetwork.europe.0.name}"
}

output "secondary_ip_range_pods" {
  value = "${google_compute_subnetwork.europe.0.secondary_ip_range.0.range_name}"
}

output "secondary_ip_range_services" {
  value = "${google_compute_subnetwork.europe.0.secondary_ip_range.1.range_name}"
}