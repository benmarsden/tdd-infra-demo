Feature: All GCS buckets should be located in EUROPE-NORTH1
    In order to make sure the GCP GCS bucket location is correct
    I have the following test scenarios:

    Scenario Outline: Naming Standard on all available resources
        Given I have <resource_name> defined
        When it contains <name_key>
        Then its value must match the "EUROPE-NORTH1" regex

        Examples:
        | resource_name         | name_key |
        | google_storage_bucket | location |
