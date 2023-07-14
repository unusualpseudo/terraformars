resource "aws_iam_openid_connect_provider" "github_oidc" {

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}




resource "aws_iam_role" "read_role" {
  name = "read-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          "Federated" : "arn:aws:iam::0123456789:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:unusualpseudo/terraformars:pull_request",
              "repo:unusualpseudo/terraformars:ref:refs/heads/main"
            ],
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}


resource "aws_iam_policy" "read_policy" {
  name = "read-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:ListBucket*"]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}"
        ]
      },
      {
        "Action" : ["s3:GetObject"],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}/*",
        ]
      }
    ],
  })
}


resource "aws_iam_role_policy_attachment" "read_role_policy_attachment" {
  role       = aws_iam_role.read_role.name
  policy_arn = aws_iam_policy.read_policy.arn
}

resource "aws_iam_role" "write_role" {
  name = "write-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          "Federated" : "arn:aws:iam::0123456789:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:unusualpseudo/terraformars:push",
              "repo:unusualpseudo/terraformars:ref:refs/heads/main"
            ],
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}


resource "aws_iam_policy" "write_policy" {
  name = "write-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:ListBucket*"]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}"
        ]
      },
      {
        "Action" : ["s3:GetObject", "s3:PutObject"],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}/*",
        ]
      }
    ],
  })
}


resource "aws_iam_role_policy_attachment" "write_role_policy_attachment" {
  role       = aws_iam_role.write_role.name
  policy_arn = aws_iam_policy.write_policy.arn
}
