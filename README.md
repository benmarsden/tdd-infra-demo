# tdd-infra-demo

This repository aims to summarise, in a interactive way, the options available when testing infrastructure code.

It can be 'played' in one of two ways:

1. For those who prefer a walkthrough, follow the 'Walkthrough' section.
2. For those who prefer to learn by doing, read the 'Mission' section for a TDD adventure.

# Testing tools

### 1. In this demo
* [terratest](https://github.com/gruntwork-io/terratest): Go library for writing automated tests for your terraform code. 
* [terraform-compliance](https://github.com/eerkunt/terraform-compliances): BDD for terraform.
* [Open Policy Agent](https://www.openpolicyagent.org/): general-purpose policy engine that allows you to create enforceable policies across terraform, k8s resources and more!
* [conftest](https://github.com/instrumenta/conftest): Write tests against Open Policy Agent policies
* [pre-commit](https://github.com/gruntwork-io/pre-commit): runs terraform-fmt, terraform-validate, tflint, golint and gofmt prior to every commit.

### 2. Outside scope of demo (but interesting)

* [terraform-validate](https://github.com/elmundio87/terraform_validate): a python library to enable policy-as-code over terraform files.
* [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform): Compare desired vs actual terraform state after `terraform apply`ing with Chef's [InSpec](https://www.inspec.io/).

# Dependencies

* Google Cloud project with billing configured
  * provide the project name and project ID as variables (either by passing them as -var or using a .tfvars file)
* Testing tools defined above
* `make` (if you wish to use the Makefile)
* terraform
* go

# Walkthrough
<details>
  <summary>Click here for the walkthrough</summary>
  
1. Before all else, get yourself set up with pre-commit: 
  * `brew install pre-commit`
  * `pre-commit install`
  * test setup with `make pre-commit`
2. Let's now learn how we can use terraform-compliance to use BDD to test our terraform code. Run `make compliance`.
  * to use terraform-compliance, we create features and scenarios with the usual given/when/then syntax. See tests/compliance for examples of this.
  * `make compliance` evaluates our scenarios against a terraform plan and notifies us of any failures.
  * there are 3 failures: incorrect bucket location, incorrect bucket naming and incorrect bucket admin priviledges. Try fixing them and re-running `make compliance` to verify your fixes.
2. We can also use OPA's query language, Rego, to create policies for interpreting structured data (in our case a terraform plan, or a terraform configuration file). Run `make opa`.
  * `make opa` runs our Rego policies across a terraform plan and returns both the policy results and coverage over the policies.
    * The policies are themselves only assertions, and we can use `conftest` as a way to run tests against these assertions locally and in CI.
    * Run `make conftest-tfplan`. This will generate a terraform plan in .json format, evaluate the policies outlined in tests/policy/bucket_admin.rego and test whether the `deny[msg] ...` defined there is true. 
    * Fix the issue by associating `bmarsden10@gmail.com` with roles/storage.admin of `data.google_iam_policy.naughty-admin`. What happens when you re-run `make conftest-tfplan`?
    * As an interesting alternative, run `make conftest-tf`. This uses conftest to test against the .tf files directly (as opposed to against the terraform plan).
3. Thought we were done with OPA and conftest? Not quite! We can take conftest even further by writing tests to validate our OPA policies:
  * tests/policy/bucket_admin_test.rego defines the `test_is_bucket_policy`, which creates a dummy resource to validate the response of the `is_bucket_policy` function. 
  * In this way, we can not only ensure trust in our infrastructure code, but also in the policies applied to it too!
  * Run `make conftest-validate` to see this in action.
4. Great, so now we have a bucket that theoretically adheres to our defined policies. To wrap it up, let's learn how to test this is true in practise using Terratest!
  * Run `make terratest`. 
  * This runs the `TestBucketCreation` Go test in tests/unit/bucket_test.go, which uses the real terraform scripts in infra/project_init with test-specific variables to assert certain attributes about the created bucket are true.
  * Of course, this is a rather mundane example, but it illustrates a powerful aspect of terratest: testing your infrastructure code **in a real environment**.
</details>

# Mission
<details>
  <summary>Click here for the mission</summary>
  
  ## Defeat Lord Buckethead

The mischevious intergalatic spacelord [Lord Buckethead](https://www.youtube.com/watch?v=6eQ0s4SBefU) is back! Since his Brexit schenanigans, he's trying to resupply his barbaric bucket army by sneaking his way into your Google Cloud Storage buckets!

Luckily, because of our rigorous infrastructure testing practices, we've identified 3 changes to your terraform files that indicate Lord Buckethead has infiltrated your systems. While we don't know exactly what these are, we do know the following 3 things about this particularly devious intergalactic spacelord:

1. If he ever hopes to defeat Boris Johnson, Lord Buckethead needs more buckets **in the UK**.
2. Any old bucket is not good enough. If Lord Buckethead ever hopes to keep take power, he will need high-ranking buckets to lead his forces well. **Keep an eye out for suspiciously named buckets**...
3. In efforts to rebrand, Lord Buckethead may be converting his bucket army to [bins](https://www.countbinface.com). He will surely need certain **permissions** over your buckets to do this... 

Can you fix the issues and restore the integrity of our infrastructure code?

**Win condition**: `make test` passes without errors

## Hints

To help you in your quest:

* a `Makefile` has been included to allow you to execute different types of tests. Failing tests from running `make compliance` and `make conftest-tfplan` will provide indication as to what Lord Buckethead has modified.
* tests reside in the `tests/*` directories.

</details>
