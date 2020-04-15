Feature: Make sure only Ben is Lord of the buckets
    In order to make sure Ben is the only administrator over GCP buckets,
    I have the following test scenarios:

    Scenario Outline: roles/storage.admin defined in the google_storage_bucket_iam_policy.bucket-admin-policy
        Given I have <resource_name> defined
        When its name is "bucket-admin-policy"
        And it contains <name_key>
        Then it must contain <value_key>
        And its value must match the "roles/storage.admin" regex

        Examples:
        | resource_name         | name_key | value_key |
        | google_storage_bucket_iam_policy     | policy_data  | role |
    Scenario Outline: IAM admin policy applies at least to the tdd-bucket-demo
        Given I have <resource_name> defined
        When its name is "bucket-admin-policy"
        And it contains <name_key>
        Then its value must match the "tdd-bucket-demo" regex

        Examples:
        | resource_name         | name_key |
        | google_storage_bucket_iam_policy     | bucket |
    Scenario Outline: Only Ben has the roles/storage.admin role defined in the google_storage_bucket_iam_policy.bucket-admin-policy
        Given I have <resource_name> defined
        When its name is "bucket-admin-policy"
        And it contains <name_key>
        Then it must contain <value_key>
        And its value must match the <regex> regex

        Examples:
        | resource_name         | name_key | value_key | regex |
        | google_storage_bucket_iam_policy    | policy_data  | members | "user:bmarsden10@gmail.com" |
        | google_storage_bucket_iam_policy    | policy_data  | role | "roles/storage.admin" |
    Scenario Outline: Only Ben has the roles/storage.admin role defined in any google_storage_bucket_iam_policy
        Given I have <resource_name> defined
        When it contains <name_key>
        Then it must contain <value_key>
        And its value must match the <regex> regex

        Examples:
        | resource_name         | name_key | value_key | regex |
        | google_storage_bucket_iam_policy    | policy_data  | members | "user:bmarsden10@gmail.com" |
        | google_storage_bucket_iam_policy    | policy_data  | role | "roles/storage.admin" |
