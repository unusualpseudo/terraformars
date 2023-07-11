
module "dynamodb" {
  source     = "./modules/db/"
  table_name = var.table_name
}

module "s3_budget" {
  source = "./modules/budget/"
  email  = var.email
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  tags = {
    Name = "terraform"
  }
  lifecycle {
    prevent_destroy = false
  }
  depends_on = [module.dynamodb]
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
  bucket     = aws_s3_bucket.terraform_state.id
  acl        = "private"
}



resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_lifecycle_configuration" "terraform_bucket_lifecycle" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id = "versions-expiration"

    noncurrent_version_expiration {
      noncurrent_days           = 2
      newer_noncurrent_versions = 3
    }
    status = "Enabled"
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}



output "dynamodb_table_name" {
  value       = module.dynamodb.terraform_locks.name
  description = "The name of the DynamoDB table"
}
