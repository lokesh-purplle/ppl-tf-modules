variable "project" {
  description = "Set thje GCP project name"
  type        = string
}

variable "region" {
  description = "Set thje GCP project name"
  type        = string
  default     = "asia-east1"
}

variable "tfstate_key" {
  description = "Set the path for the key file"
  type        = string
}

variable "vm_prefix" {
  description = "Set the the prefix for the VM names"
  type        = string
}


variable "machine_type" {
  description = "Set the VM machine type"
  type        = string
}

# variable "disk_size" {
#     description = "Set the VM disk size"
#     type = number
# }

variable "enable_additional_disk" {
  description = "Set if you want to enable additional disk"
  type        = bool
}

variable "additional_disk_size" {
  description = "Set the additional disk size"
  type        = number
}

variable "additional_disk_mount_point" {
  description = "Set the additional mount point"
  type        = string
}
variable "additional_disk_type" {
  description = "Set the additional disk type"
  type        = string
}


variable "gcp_network_tags" {
  description = "comma separated list of tags to add to the VM"
  type        = list(any)
  default     = []
}


variable "gcp_subnetwork" {
  description = "Set the GCP subnetwork self link"
  type        = string

}

variable "gcp_image" {
  description = "Set the image name"
  type        = string
  default     = ""

}

variable "vm_count" {
    description = "Enter the number of VMs to create"
    type        = list
    default     = []
}  
