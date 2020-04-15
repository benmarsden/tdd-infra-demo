variable "project_name" {
  default     = "tdd-infra-demo"
  description = "Google Cloud Project to launch resources in"
}

variable "project_id" {
  default     = "tdd-infra-demo-d69d723e"
  description = "Google Cloud Project ID to launch resources in"
}

variable "region" {
  default     = "europe-north1"
  description = "The region to launch all the nodes in"
}

variable "zone" {
  default     = "europe-north1-a"
  description = "The zone to launch all the nodes in"
}

variable "bucket_name" {
  default = "tdd-bucket-demo"
}

variable "bucket_location" {
  default = "EUROPE-NORTH1"
}
