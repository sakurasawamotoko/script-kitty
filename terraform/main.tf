provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_lambda_function" "scriptkitty_lambda_function" {
  function_name = "scriptkitty-lambda-function"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "058264132929.dkr.ecr.ap-northeast-1.amazonaws.com/scriptkitty-lambda-function:latest"

  environment {
    variables = {
      ENV_VAR_NAME = "value"
    }
  }
}

# IAM ロール（Lambda 関数）
# IAM role for the Lambda function
# 許可ポリシー：AWSLambdaBasicExecutionRole

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

# IAM policy for Lambda to write logs to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# CloudWatch Event Rule to trigger Lambda once per day
resource "aws_cloudwatch_event_rule" "daily_lambda_trigger" {
  name        = "DailyLambdaTrigger"
  description = "Trigger Lambda function once per day"
  schedule_expression = "rate(1 day)"  # Schedule the Lambda function to run once per day
}

# Permission to allow CloudWatch Events to invoke the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch_to_invoke" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scriptkitty_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_lambda_trigger.arn
}

# Attach the Lambda function to the CloudWatch Event Rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_lambda_trigger.name
  target_id = "lambda"
  arn       = aws_lambda_function.scriptkitty_lambda_function.arn
}