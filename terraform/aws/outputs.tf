output "read_role_arn" {
  value = aws_iam_role.read_role.arn
}

output "write_role_arn" {
  value = aws_iam_role.write_role.arn
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}


output "terraform_locks" {
  value       = aws_dynamodb_table.terraform_locks.id
  description = "The id of the DynamoDB table"
}
