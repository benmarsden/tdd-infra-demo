output "project_id" {
  value = "${var.project_id}"
}

output "project_name" {
  value = "${var.project_name}"
}


output "region" {
  value = var.region
}

output "zone" {
  value = var.zone
}

output "bucket_name" {
  value = google_storage_bucket.tdd-demo-bucket.name
}

output "bucket_location" {
  value = google_storage_bucket.tdd-demo-bucket.location
}

output "bucket_id" {
  value = google_storage_bucket.tdd-demo-bucket.id
}

output "bucket_admin_policy" {
  value = google_storage_bucket_iam_policy.bucket-admin-policy
}

output "bucket_url" {
  value = google_storage_bucket.tdd-demo-bucket.url
}
