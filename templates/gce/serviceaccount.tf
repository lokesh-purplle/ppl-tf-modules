module "google_sa_workload_identity" {
  source     = "git::https://github.com/lokesh-purplle/ppl-tf-modules.git//modules/terraform-google-sa-workload-identity?ref=main"
  name       = "${var.vm_prefix}-vm"
  project_id = var.project
  roles      = ["roles/secretmanager.secretAccessor"]
}