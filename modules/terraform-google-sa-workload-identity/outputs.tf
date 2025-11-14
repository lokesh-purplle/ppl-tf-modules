###############################################################################
# Google Service Account Workload Identity Module
# -----------------------------------------------------------------------------
# outputs.tf
###############################################################################

output "gcp_service_account_email" {
  description = "Email address of GCP service account."
  value       = local.gcp_sa_email
}

output "gcp_service_account_fqn" {
  description = "FQN of GCP service account."
  value       = local.gcp_sa_fqn
}

output "gcp_service_account_name" {
  description = "Name of GCP service account."
  value       = local.k8s_sa_gcp_derived_name
}

output "gcp_service_account" {
  description = "GCP service account."
  value       = var.use_existing_gcp_sa ? data.google_service_account.cluster_service_account[0] : google_service_account.cluster_service_account[0]
}
