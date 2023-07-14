variable "bucket_name" {
  description = "name of the s3 bucket"
  type        = string
  default     = "terraformars-state"
}


variable "table_name" {
  description = "terraform state lock table name"
  type        = string
  default     = "TerraformarsStateLock"
}
