### Example

```
provider "google" {
  region  = "<gcp region>"
  project = "<gcp project id>"
}

module "web" {
  source                  = "git::https://github.com/lokesh-purplle/ppl-tf-modules.git//modules/terraform-google-compute-instance-updated?ref=main"
  disk_storage_enabled    = false                       //(optional)set true if any additional disk to be attached
  instance_name           = "testing"
  disk_storage_size       = 10
  gcp_region_zone         = "asia-east1-a"              //(optional) set gcp zone, leave empty for auto-selection
  instance_description    = "test VM"
  gcp_deletion_protection = false
  dns_create_record       = false
  disk_boot_size          = 10                          // boot disk size
  gcp_subnetwork          = "<self link to the subnet>" // specify subnetwork self link 
  gcp_preemptible         = false
  gcp_network_tags        = ["<tag1>", "<tag2>"]        // specify the network tags to be attached
  gcp_project             = "<gcp project id>"          // gcp project id
  gcp_region              = "<gcp region>"             // GCP region
  gcp_machine_type        = "<instance type>"          // GCP instance type
  assign_public_ip        = false                       // (optional)set true if you want public ip on the vm
  ssh_keys                = null                        // (optional)SSH keys in format 'username:key username2:key2'. If null, SSH keys can be managed via gcloud
}
```

### SSH Keys Management

SSH keys can be managed in two ways:

1. **Via Terraform variable** (when `ssh_keys` is provided):
   - Pass SSH keys as a string. For multiple keys, use newline-separated format:
     ```
     ssh_keys = "ubuntu:ssh-rsa AAAAB3... ubuntu@host\nlokesh:ssh-rsa AAAAB3... lokesh@host"
     ```
   - Or use a multi-line string in terraform.tfvars:
     ```
     ssh_keys = <<-EOT
       ubuntu:ssh-rsa AAAAB3... ubuntu@host
       lokesh:ssh-rsa AAAAB3... lokesh@host
     EOT
     ```
   - Keys will be added to instance metadata during creation

2. **Via gcloud** (when `ssh_keys` is null/not provided):
   - SSH keys are not set via Terraform
   - Use `gcloud compute instances add-metadata` to add SSH keys after instance creation
   - This is the preferred method for multi-cluster operations and centralized key management

Note: `block-project-ssh-keys = true` is always set to prevent project-level SSH keys from being used.
