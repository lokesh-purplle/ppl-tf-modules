terraform {
  required_version = ">= 1.3"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.48.0, < 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.48.0, < 5.0"
    }
  }
}