variable "cluster_name" {
	description = "Cluster to attach this node_pool to"
}
variable "zone" {
	default     = "europe-west4-b"
	description = "Zone to locate cluster in"
}
variable "name" {
	default     = "gkepowered"
	description = "Cluster name"
}
variable "kube_version" {
	default     = "1.22.17-gke.5400"
	description = "Desired GKE kubernetes version. Refer to https://cloud.google.com/kubernetes-engine/docs/release-notes"
}
variable "initial_node_count" {
	default     = "3"
	description = "Initial - num of node created at the start"
}
variable "min_node_count" {
	default     = "3"
	description = "Min num of nodes kept online"
}
variable "max_node_count" {
	default     = "9"
	description = "Max num of nodes to scale to"
}
variable "auto_repair" {
	default     = "true"
	description = "GKE node pool management auto repair"
}
variable "auto_upgrade" {
        default     = "true"
        description = "GKE node pool management auto upgrade"
}

variable "network_tags" {
	default     = [""]
	description = "Nodes network tags"
}
variable "oauth_scopes" {
	default     = [ "https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring" ]
	description = "Default scopes to allow GKE to use GCP stuff"
}
variable "preemptible" {
	default     = "false"
	description = "Provision node_pool on GCP spot instances"
}
variable "machine_type" {
	default     = "n1-standard-2"
}
variable "disk_type" {
	default     = "pd-ssd"
	description = "Can also be pd-standard"
}
variable "disk_size" {
	default     = "30"
	description = "In gigabytes"
}

variable "image_type" {
  default = "COS_CONTAINERD"
}

variable "spot" {
  default = "true"
}

variable "create_pod_range" {
  default = true
}

variable "enable_private_nodes" {
  default = false
}

variable "pod_ipv4_cidr_block" {
  default = "gke-data-science-cluster-pods-617c478b"
}