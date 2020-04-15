Feature: All resource names should be project-scoped
    In order to make sure the GCP GCS bucket naming is consistent
    I have the following test scenarios:

    Scenario Outline: Naming standard on all available resources
        Given I have <resource_name> defined
        When it contains <name_key>
        Then its value must match the "tdd-.*-demo" regex

        Examples:
        | resource_name         | name_key |
        | google_storage_bucket | name |
        | google_project        | name     |
