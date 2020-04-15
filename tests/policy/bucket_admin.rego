# test the terraform plan

package bucket_admin

is_resource_of_type(resource, type) {
    resource.type == type
}

is_gcs_bucket(resource) {
    is_resource_of_type(resource, "google_storage_bucket")
}

is_bucket_policy(resource) {
    is_resource_of_type(resource, "google_storage_bucket_iam_policy")
}

is_bucket_admin_policy(resource) {
	is_resource_of_type(resource, "google_storage_bucket_iam_policy")
	contains(resource.change.after.policy_data, "storage.admin")
}

is_bucket_with_ben_admin(resource) {
	contains(resource.change.after.policy_data, "bmarsden10@gmail.com")
}

all_bucket[policy] {
    resource := input.resource_changes[i]
    policy := gcs_bucket_policies[j]
    admin_policy := gcs_bucket_policies[j]

}

buckets_with_admin_policy[admin_policy] {
    resource := input.resource_changes[i]
    admin_policy := gcs_bucket_ben_admin_policies[j]
}

buckets_without_admin_policy[buckets] {
	buckets := all_bucket - buckets_with_admin_policy
}

admin_bucket_policies[policies] {
	policies := buckets_with_admin_policy[_].change.after.policy_data
}


gcs_bucket_ben_admin_policies[policy] {
	policy := input.resource_changes[i]
    is_bucket_admin_policy(policy)
    is_bucket_with_ben_admin(policy)
}

gcs_bucket_policies[policy] {
	policy := input.resource_changes[i]
    is_bucket_policy(policy)
}

gcs_bucket[bucket] {
    bucket := input.resource_changes[i]
    is_gcs_bucket(bucket)
}

buckets_without_ben_admin[buckets] {
    buckets := gcs_bucket_policies - gcs_bucket_ben_admin_policies
}

deny[msg] {
    resources := buckets_without_ben_admin
    resources != {set()}
    msg := sprintf("There are buckets in which bmarsden10@gmail.com is not an administrator: %v", [resources])
}
