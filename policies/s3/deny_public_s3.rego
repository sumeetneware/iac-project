package terraform.security

deny contains msg if {
  bucket := input.resource_changes[_]

  bucket.type == "aws_s3_bucket"

  not public_access_block_exists

  msg := sprintf(
    "S3 bucket '%s' must have public access blocked",
    [bucket.name]
  )
}

public_access_block_exists if {
  block := input.resource_changes[_]

  block.type == "aws_s3_bucket_public_access_block"

  block.change.after.block_public_acls == true
  block.change.after.block_public_policy == true
  block.change.after.ignore_public_acls == true
  block.change.after.restrict_public_buckets == true
}