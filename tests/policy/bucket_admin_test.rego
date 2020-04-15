package bucket_admin

test_is_bucket_policy {
    resource := { "type": "google_storage_bucket_iam_policy" }
    is_bucket_policy(resource)
}

test_is_bucket_policy {
    resource := { "type": "google_storage_bucket" }
    is_bucket_policy(resource)
}
