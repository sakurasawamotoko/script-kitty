##############################################
# GitHub Actions OIDC Provider
# GitHub Actions 用 OIDC プロバイダー
##############################################

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  # GitHub OIDC known thumbprint
  # GitHub OIDC の既知のサムプリント
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

##############################################
# IAM Role for GitHub Actions to assume
# GitHub Actions が引き受ける IAM ロール
##############################################

resource "aws_iam_role" "github_actions_oidc_role" {
  name = "github-actions-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # IMPORTANT:
            # Must match *exact* GitHub repository name + branch
            # 必須：GitHub リポジトリ名とブランチを正確に指定する
            "token.actions.githubusercontent.com:sub" : "repo:sakurasawamotoko/script-kitty:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

##############################################
# Permissions for GitHub Actions CI/CD
# GitHub Actions からのデプロイ用の権限
##############################################

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "github_actions_oidc_policy" {
  name = "github-actions-oidc-policy"
  role = aws_iam_role.github_actions_oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      ##############################################
      # ECR permissions
      # ECR への push/pull 権限
      ##############################################
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },

      ##############################################
      # Lambda deployment permissions
      # Lambda のデプロイ権限
      ##############################################
      {
        Effect = "Allow"
        Action = [
          "lambda:GetFunction",
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration"
        ]
        Resource = "arn:aws:lambda:ap-northeast-1:${data.aws_caller_identity.current.account_id}:function:scriptkitty-lambda-function"
      },

      ##############################################
      # CloudWatch Logs permissions
      # CloudWatch Logs の作成権限
      ##############################################
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },

      ##############################################
      # IAM PassRole
      # GitHub が Lambda 実行ロールをアタッチするため
      ##############################################
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = aws_iam_role.scriptkitty_lambda_role.arn
      }
    ]
  })
}
