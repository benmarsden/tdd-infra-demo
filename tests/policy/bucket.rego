# test the terraform .tf files

package bucket_general

deny[msg] {
  not input.resource.google_storage_bucket["tdd-demo-bucket"]
  msg = "'tdd-demo-bucket' bucket should be defined"
}

deny[msg] {
  not input.resource.google_storage_bucket["tdd-demo-bucket"].project
  msg = "'tdd-demo-bucket' bucket should specify its associated project explicitly"
}

deny[msg] {
  not contains(input["resource.google_storage_bucket.tdd-demo-bucket"].location, "EUROPE-NORTH1")
  msg = "'tdd-demo-bucket' bucket should be located in the EUROPE-NORTH1 region"
}
