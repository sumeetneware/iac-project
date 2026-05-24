resource "aws_s3_bucket" "storage" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Project     = "IaC-Project"
  }
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.storage.id

  versioning_configuration {
    status = "Enabled"
  }
}



resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}




resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}