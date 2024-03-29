locals {
  # GCP service account ids must be <= 30 chars matching regex ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$
  # KSAs do not have this naming restriction.
#  gcp_given_name = var.gcp_sa_name != null ? var.gcp_sa_name : trimsuffix(substr(var.name, 0, 30), "-")
  gcp_given_name       = var.k8s_sa_name != null ? var.k8s_sa_name : var.name
  gcp_sa_email   = var.use_existing_gcp_sa ? data.google_service_account.cluster_service_account[0].email : google_service_account.cluster_service_account[0].email
  gcp_sa_fqn     = "serviceAccount:${local.gcp_sa_email}"

  # This will cause Terraform to block returning outputs until the service account is created
  k8s_given_name       = var.k8s_sa_name != null ? var.k8s_sa_name : var.name
  output_k8s_name      = local.k8s_given_name

  k8s_sa_project_id       = var.k8s_sa_project_id != null ? var.k8s_sa_project_id : var.project_id
  k8s_sa_gcp_derived_name = "serviceAccount:${local.k8s_sa_project_id}.svc.id.goog[${var.namespace}/${local.output_k8s_name}]"

  sa_binding_additional_project = distinct(flatten([for project, roles in var.additional_projects : [for role in roles : { project_id = project, role_name = role }]]))
}

data "google_service_account" "cluster_service_account" {
  count = var.use_existing_gcp_sa ? 1 : 0

  account_id = local.gcp_given_name
  project    = var.project_id
}

resource "google_service_account" "cluster_service_account" {
  count = var.use_existing_gcp_sa ? 0 : 1

  account_id   = local.gcp_given_name
  display_name = coalesce(var.gcp_sa_display_name, substr("GCP SA bound to K8S SA ${local.k8s_sa_project_id}[${local.k8s_given_name}]", 0, 100))
  description  = var.gcp_sa_description
  project      = var.project_id
}


resource "google_service_account_iam_member" "main" {
  count = var.k8s_sa_name != null? 1 : 0 
  service_account_id = var.use_existing_gcp_sa ? data.google_service_account.cluster_service_account[0].name : google_service_account.cluster_service_account[0].name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_sa_gcp_derived_name
}

resource "google_project_iam_member" "workload_identity_sa_bindings" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = local.gcp_sa_fqn
}

resource "google_project_iam_member" "workload_identity_sa_bindings_additional_projects" {
  for_each = { for entry in local.sa_binding_additional_project : "${entry.project_id}.${entry.role_name}" => entry }

  project = each.value.project_id
  role    = each.value.role_name
  member  = local.gcp_sa_fqn
}
