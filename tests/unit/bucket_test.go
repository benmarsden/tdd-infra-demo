package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestBucketCreation(t *testing.T) {
	t.Parallel()

	// Create all resources in the following zone
	zone := "europe-north1-a"

	exampleDir := test_structure.CopyTerraformFolderToTemp(t, "../../", "infra")
	// Give the example bucket a unique name so we can distinguish it from any other bucket in your GCP account
	expectedBucketName := fmt.Sprintf("terratest-bucket-example-%s", strings.ToLower(random.UniqueId()))

	// Configure Terraform setting path to Terraform code, bucket name.
	terraformOptions := &terraform.Options{

		// The path to where our Terraform code is located
		TerraformDir: exampleDir,

		// VarFiles: []string{"../../tests/unit/bucket_test.tfvars"},

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"zone":        zone,
			"bucket_name": expectedBucketName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of some of the output variables
	bucketURL := terraform.Output(t, terraformOptions, "bucket_url")

	// Verify that the new bucket url matches the expected url
	expectedURL := fmt.Sprintf("gs://%s", expectedBucketName)
	assert.Equal(t, expectedURL, bucketURL)

	// Verify that the Storage Bucket exists
	gcp.AssertStorageBucketExists(t, expectedBucketName)
}
