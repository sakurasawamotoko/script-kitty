provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_lambda_function" "scriptkitty_lambda_function" {
  function_name = "my-lambda-function"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "your-account-id.dkr.ecr.your-region.amazonaws.com/my-lambda-function:latest"

  environment {
    variables = {
      ENV_VAR_NAME = "value"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "scriptkitty_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  ]
}