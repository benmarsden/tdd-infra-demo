resource "google_storage_bucket" "tdd-demo-bucket" {
  name          = var.bucket_name
  project       = var.project_id
  location      = "EUROPE-NORTH1"
  force_destroy = true

  bucket_policy_only = false
  lifecycle_rule {
    condition {
      age = "3"
    }
    action {
      type = "Delete"
    }
  }
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:bmarsden10@gmail.com",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "bucket-admin-policy" {
  bucket      = google_storage_bucket.tdd-demo-bucket.name
  policy_data = data.google_iam_policy.admin.policy_data
}

resource "google_storage_bucket" "tdd-naughty-bucket" {
  name          = "general-bucketface"
  project       = var.project_id
  location      = "EUROPE-WEST2"
  force_destroy = true

  bucket_policy_only = false
  lifecycle_rule {
    condition {
      age = "3"
    }
    action {
      type = "Delete"
    }
  }
}

data "google_iam_policy" "naughty-admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:lord@buckethead.io",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "bucket-naughty-admin-policy" {
  bucket      = google_storage_bucket.tdd-naughty-bucket.name
  policy_data = data.google_iam_policy.naughty-admin.policy_data
}
