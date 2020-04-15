# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM REQUIREMENTS FOR RUNNING THIS MODULE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 0.12.6"
}

provider "google" {
  project = var.project_name
  region  = var.region
  zone    = var.zone
}
