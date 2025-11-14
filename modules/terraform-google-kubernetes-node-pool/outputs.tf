###############################################################################
# Google Kubernetes Engine Node Pool Module
# -----------------------------------------------------------------------------
# outputs.tf
###############################################################################

output "node_pool" {
  description = "The GKE node pool resource"
  value       = google_container_node_pool.gke-nodes
}

output "node_pool_name" {
  description = "Name of the GKE node pool"
  value       = google_container_node_pool.gke-nodes.name
}

output "node_pool_id" {
  description = "ID of the GKE node pool"
  value       = google_container_node_pool.gke-nodes.id
}

output "node_pool_location" {
  description = "Location (zone) of the GKE node pool"
  value       = google_container_node_pool.gke-nodes.location
}

output "node_pool_cluster" {
  description = "Cluster name this node pool belongs to"
  value       = google_container_node_pool.gke-nodes.cluster
}

output "node_pool_instance_group_urls" {
  description = "List of instance group URLs which have been assigned to this node pool"
  value       = google_container_node_pool.gke-nodes.instance_group_urls
}

output "node_pool_managed_instance_group_urls" {
  description = "List of managed instance group URLs which have been assigned to this node pool"
  value       = google_container_node_pool.gke-nodes.managed_instance_group_urls
}

output "autoscaling" {
  description = "Autoscaling configuration for the node pool"
  value = {
    min_node_count = google_container_node_pool.gke-nodes.autoscaling[0].min_node_count
    max_node_count = google_container_node_pool.gke-nodes.autoscaling[0].max_node_count
  }
}

output "management" {
  description = "Management configuration for the node pool"
  value = {
    auto_repair  = google_container_node_pool.gke-nodes.management[0].auto_repair
    auto_upgrade = google_container_node_pool.gke-nodes.management[0].auto_upgrade
  }
}

