resource "aws_iam_openid_connect_provider" "github_oidc" {

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}



resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow"
        "Action" = "sts:AssumeRoleWithWebIdentity"
        "Principal" = {
          "Federated" = aws_iam_openid_connect_provider.github_oidc.arn
        },
        "Condition" = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:unusualpseudo/terraformars:pull_request",
              "repo:unusualpseudo/terraformars:push",
              "repo:unusualpseudo/terraformars:ref:refs/heads/main"
            ],
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_actions_s3_access_policy" {
  name        = "s3-github-actions-access-policy"
  description = "IAM policy for S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
        "s3:*"]
        Effect = "Allow"
        Resource = [
          format("%s/%s", aws_s3_bucket.terraform_state.arn, "*")
        ]
      },
      {
        Action = ["s3:PutObject"]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.terraform_state.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "budget_access_policy" {
  name        = "budget-access-policy"
  description = "IAM policy for AWS budget access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "budgets:ViewBudget"
        ]
        Resource = [
          aws_budgets_budget.aws_daily_budget.arn,
          aws_budgets_budget.s3_monthly_budget.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_s3_access_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_budget_access_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.budget_access_policy.arn
}
