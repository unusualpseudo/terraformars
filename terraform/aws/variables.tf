variable "bucket_name" {
  description = "Name of the s3 bucket"
  type        = string
  default     = "terraformars-state"
}


variable "table_name" {
  description = "Terraform state lock table name"
  type        = string
  default     = "TerraformarsStateLock"
}
