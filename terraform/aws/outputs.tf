output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "The arn github actions role"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The arn of the S3 bucket"
}

output "terraform_locks" {
  value       = aws_dynamodb_table.terraform_locks.arn
  description = "The arn of the DynamoDB table"
}


output "aws_daily_budget" {
  value       = aws_budgets_budget.aws_daily_budget.arn
  description = "The arn of the daily budget resource"
}


output "s3_monthly_budget" {
  value       = aws_budgets_budget.s3_monthly_budget.arn
  description = "The id of the monthly budget resource"
}
