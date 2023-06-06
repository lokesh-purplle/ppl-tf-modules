### Example

```
provider "google" {
  region  = "<gcp region>"
  project = "<gcp project id>"
}

module "web" {
  source                  = "./modules/terraform-google-compute-instance/"
  disk_storage_enabled    = false                       //(optional)set true if ant additonal disk to be attached
  instance_name           = "testing"
  disk_storage_size       = 10
  gcp_region_zone         = "asia-east1-a"              //(optiona) set gpp zone
  instance_description    = "test VM"
  gcp_deletion_protection = false
  dns_create_record       = false
  disk_boot_size          = 10 // boot disk size
  gcp_subnetwork          = "<self link to the subnet>" // specify subnetwork self link 
  gcp_preemptible         = false
  gcp_network_tags        = ["<tag1>", "<tag2>"]        // specify the network tags to be attached
  gcp_project             = "<gcp project id>"          // gcp project id
  gcp_region              = "<gcp  region>"             //GCP region
  gcp_machine_type        = "<instaqnce type>"          //GCP instance type
  assign_public_ip        = false                       // (optional)set true if you want public ip on the vm
}
```
