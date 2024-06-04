
module "testing_vm_1" {
  for_each = toset(var.vm_count)
  source                  = "git::https://github.com/lokesh-purplle/ppl-tf-modules.git//modules/terraform-google-compute-instance-updated?ref=main"
  gcp_machine_type        = var.machine_type
  gcp_project             = "purpllesandboxtier"
  gcp_region              = var.region
  instance_name           = "${var.vm_prefix}-${each.key}"
  disk_storage_enabled    = var.enable_additional_disk
  disk_storage_mount_path = var.additional_disk_mount_point
  gcp_network_tags        = var.gcp_network_tags
  disk_storage_size       = var.additional_disk_size
  labels                  = { ansible = "${var.vm_prefix}" }
  service_account         = module.google_sa_workload_identity.gcp_service_account_email
  gcp_subnetwork          = var.gcp_subnetwork
  gcp_image = var.gcp_image
  additional_disk_type = var.additional_disk_type
}
