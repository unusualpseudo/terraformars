
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}


output "terraform_locks" {
  value       = aws_dynamodb_table.terraform_locks
  description = "The name of the DynamoDB table"
}
