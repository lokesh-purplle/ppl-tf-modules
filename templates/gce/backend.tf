terraform {
  backend "gcs" {
    bucket  = "purplle-terraform-state"
    prefix  = "purplle/sandbox/asia-east1/instances/testing/"
   }
}