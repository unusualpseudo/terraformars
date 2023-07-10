resource "aws_budgets_budget" "cost" {
  name              = "daily_cost"
  budget_type       = "COST"
  limit_amount      = "1"
  limit_unit        = "USD"
  time_unit         = "DAILY"
  time_period_start = "2023-03-18_00:00"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.email]
  }

}


resource "aws_budgets_budget" "s3_storage_budget" {
  name         = "s3_budget"
  budget_type  = "USAGE"
  limit_amount = "5"
  limit_unit   = "GB"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "UsageTypeGroup"
    values = ["Amazon S3"]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.email]
  }
}
