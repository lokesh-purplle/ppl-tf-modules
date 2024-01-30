###############################################################################
# Google Compute Instance Configuration Module
# -----------------------------------------------------------------------------
# outputs.tf
###############################################################################

output "disk_boot" {
  value = {
    size = var.disk_boot_size
  }
}

output "disk_storage" {
  value = {
    enabled    = var.disk_storage_enabled
    mount_path = var.disk_storage_mount_path
    size       = var.disk_storage_size
  }
}


output "gcp" {
  value = {
    deletion_protection = var.gcp_deletion_protection
    image               = var.gcp_image
    machine_type        = var.gcp_machine_type
    project             = var.gcp_project
    region              = var.gcp_region
    region_zone         = var.gcp_region_zone
  }
}

output "instance" {
  value = {
    description = google_compute_instance_from_machine_image.instance.description
    hostname    = google_compute_instance_from_machine_image.instance.hostname
    id          = google_compute_instance_from_machine_image.instance.id
    name        = google_compute_instance_from_machine_image.instance.name
    self_link   = google_compute_instance_from_machine_image.instance.self_link
  }
}

output "labels" {
  value = var.labels
}

