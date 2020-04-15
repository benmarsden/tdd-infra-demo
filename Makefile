all: init test

init: 
	cd infra/ && \
	terraform init
	pre-commit install

test: pre-commit compliance opa conftest-tfplan conftest-tf conftest-validate terratest

terraform:
	cd infra/ && \
	terraform init && \
	terraform plan && \
	terraform apply -auto-approve

destroy:
	cd infra/ && terraform destroy -auto-approve

clean:
	cd infra/ && rm -rf .terraform terraform.tfstate terraform.tfstate.backup tfplan.out tfplan.out.json

# Testing

pre-commit:
	pre-commit run --all-files

# we can use terraform-compliance to use BDD when writing test for our terraform code
compliance:
	cd infra && terraform init && terraform plan -out=tfplan.out
	terraform-compliance -f tests/compliance -p infra/tfplan.out 

# We can use OPA to evaluate our rego policies across a terraform plan json output and give us coverage data
opa:
	cd infra && terraform init && terraform plan -out=tfplan.out
	cd infra && terraform show -json tfplan.out > tfplan.out.json
	cd tests && \
	opa eval --format pretty --data policy/bucket_admin.rego --input ../infra/tfplan.out.json "data.bucket_admin" --fail --coverage

# We can use conftest to add tests to the rego policies (e.g. deny) and run these tests across a json-formatted terraform plan
conftest-tfplan:
	cd infra && terraform init && terraform plan -out=tfplan.out && \
	terraform show -json tfplan.out > tfplan.out.json
	cd tests && \
	conftest test -p policy/bucket_admin.rego ../infra/tfplan.out.json --all-namespaces -o table

# ... or can also use conftest to test the .tf files directly
conftest-tf: 
	cd tests && \
	conftest test -p policy/bucket.rego  ../infra/bucket.tf -i hcl --all-namespaces -o table

# WE CAN EVEN take it another level, and provide example scenarios to test our rego policies
# against to verify that they work as expected.
conftest-validate:
	cd tests && \
	conftest verify -o table

# finally, we can tie it all together by using terratest to deploy and test our code into a real environment.
terratest:
	go test -v -timeout 30m ./tests/unit
