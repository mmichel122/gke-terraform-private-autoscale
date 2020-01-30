provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "remote" {
    organization = "sky-uk-cec"
    workspaces {
      name = "cec-terraform-gcp-automation-platform"
    }
  }
}