output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

output "terraform_locks" {
  value       = aws_dynamodb_table.terraform_locks.arn
  description = "The id of the DynamoDB table"
}
