###############################################################################
# Google Compute Instance Configuration Module
# -----------------------------------------------------------------------------
# main.tf
###############################################################################

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.0"
    }
  }
}

############locals#############
locals {
  public_ip = var.assign_public_ip ? [null] : []
  nw_tags   = var.gcp_network_tags != [] ? concat(var.gcp_network_tags, ["vpn-ssh"]) : ["vpn-ssh"]
}

data "google_compute_zones" "available" {
  region = var.gcp_region
}

resource "random_shuffle" "az" {
  count        = var.gcp_region_zone == "" ? 1 : 0
  input        = data.google_compute_zones.available.names
  result_count = 1
}


# Create additional disk volume for instance
resource "google_compute_disk" "storage_disk" {
  count = var.disk_storage_enabled ? 1 : 0

  labels = var.labels
  name   = "${var.instance_name}-storage-disk"
  size   = var.disk_storage_size
  type   = var.additional_disk_type
  #zone   = var.gcp_region_zone
  zone   = var.gcp_region_zone != "" ? var.gcp_region_zone : random_shuffle.az[0].result[0]
}

# Attach additional disk to instance, so that we can move this
# volume to another instance if needed later.
# This will appear at /dev/disk/by-id/google-{NAME}
resource "google_compute_attached_disk" "attach_storage_disk" {
  count = var.disk_storage_enabled ? 1 : 0

  device_name = "${var.instance_name}-storage-disk"
  disk        = google_compute_disk.storage_disk[0].self_link
  instance    = google_compute_instance_from_machine_image.instance.self_link
}


# Create an external IP for the instance
resource "google_compute_address" "external_ip" {
  count = var.assign_public_ip ? 1 : 0
  address_type = "EXTERNAL"
  description  = "External IP for ${var.instance_description}"
  /*
  # Although labels are supported according to the documentation, they were not
  # working during tests, so they have been commented out for now.
  labels = var.labels
  */
  name   = "${var.instance_name}-network-ip"
  region = var.gcp_region
}

# Create a Google Compute Engine VM instance with public ip
resource "google_compute_instance_from_machine_image" "instance" {
    provider = google-beta
  description               = var.instance_description
  deletion_protection       = var.gcp_deletion_protection
  name                      = var.instance_name
  machine_type              = var.gcp_machine_type
  #zone                      = var.gcp_region_zone
  project = var.gcp_project
  zone                      = var.gcp_region_zone != "" ? var.gcp_region_zone : random_shuffle.az[0].result[0]
  source_machine_image = "projects/purpllesandboxtier/global/machineImages/hardened-ubuntu2204"
  allow_stopping_for_update = true


  shielded_instance_config {
enable_secure_boot = true
}
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  labels = var.labels

  # This ignored_changes is required since we use a separate resource for attaching the disk
  lifecycle {
    ignore_changes = [attached_disk]
  }

  # Attach the primary network interface to the VM
  network_interface {
    subnetwork = var.gcp_subnetwork
    dynamic "access_config" {
      for_each = local.public_ip
      content {
	      nat_ip = google_compute_address.external_ip[0].address
      }
    }

  }


  # Execute the script to format & mount /var/opt
  metadata = {
    block-project-ssh-keys = true
    startup-script = var.disk_storage_enabled ? file("${path.module}/init/mnt_dir.sh") : null
    MOUNT_DIR      = var.disk_storage_mount_path
    REMOTE_FS      = "/dev/sdb"
    ssh-keys = <<EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrWtOAD39kvgQCSrFbNARmvJVwVUOrMZH9RVkJXcm4Bo72xVTDw/bLz1psTqUBT3uQFIlkDfxyI4vf5CdKUofIeexsax6ant7Eh7xNzSkPycEJIoktCwAU86IbIC+awGUTCMWI4pdku9lzVWHsMiuSr9jLLCnh9Z9fO/Z+nOrPvZIRfWzPYO57LAAA9R28qDIvw7KZWSuVLc1mdfRVzdSlgQUUHNRGxhrvVJ0+jA56PvbSvdulck3wUBP81MvKuarEEvkUxDteGxPyz+Op1YKIDZCF30fzOjg6V5X8xlTJ5GzwSikRabH8KDt4p8FYbDGf7JS7Y1xA69/6AltzzHUXn6bCIAAT+JRyFh1m715THGLLnw8ez0X8V42Z62bL1LvLf8QLp3liwMXjMUZzexqOH2YUA/iDV9wMu52tY0FrWkdrxjhd4Io534474x5tQt+WfdyqGv3QHbP+HWGPxUG28Iwm6H1qM/BSBwBpbgvvkxwOSFwcAvOmfJQueUwboWM= ubuntu@jenkins-automation-sandbox
                lokesh.j:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3S8sI+j1F2hwtItaE4o3qn4B08aTNN3+hA47UlorDEsnmmbJmoduuGgVtrIDUxX7FVYi5ACq35fs3vzOFaWI6CcrePckuB+zJcyyddjMpNvZZjCpyX++LRNZjq3ltzBdNt0Aa8+8SLuWmlPrZxDwa8CBdo1e1T3Zjbplps1Zt1v7ri28UPBMyL6mnCGglGr+bKgQrPm41phcPxw7GmdPDQhxrxdNRdlQG+iM8AbYUfQbRj60mf88lQFmS1hFz5qPx/6e7FcJwkDeWUJkXzRz5/aSpxxHVt4wPyZ+8LScOd4WJxkhUo38xBhrZLsZWxj2UhrCvbRoIeCpDE+DqtFEiR7wDVFO6XHbEwdNGKZ7Zc1Zv6+U7bNJglovI7qZsZESTNrQ/8rs6VxJRQwXBiLRnzJdRcMmpjIvr5P3Jl34N/Ixv3vulsP8RhhVJg2lydoyc1d97J36iI3kHccuuUaGI+GsPRZ/QbDxC9e7ysiJD53R5CCQsdYJPT5TZnS2JXls= lokesh.j@purplle.com
    EOT
  }

  # Tags in GCP are only used for network and firewall rules. Any metadata is
  # defined as a label (see above).
  tags = local.nw_tags

}
