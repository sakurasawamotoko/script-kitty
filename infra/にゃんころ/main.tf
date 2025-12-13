provider "aws" {
  region = "ap-northeast-1"
}

# Lambda 関数用 IAM ロール
# Lambda IAM Role
resource "aws_iam_role" "scriptkitty_lambda_role" {
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
}

# Lambda ロールに AWSLambdaBasicExecutionRole をアタッチ
# Attach AWSLambdaBasicExecutionRole to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.scriptkitty_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Docker イメージを使用する Lambda 関数
# Lambda function using Docker image
resource "aws_lambda_function" "scriptkitty_lambda_function" {
  function_name = "scriptkitty-lambda-function"
  role          = aws_iam_role.scriptkitty_lambda_role.arn
  package_type  = "Image"
  image_uri     = "058264132929.dkr.ecr.ap-northeast-1.amazonaws.com/scriptkitty-lambda-function:latest"

  environment {
    variables = {
      ENV_VAR_NAME = "value"
    }
  }
}

# Lambda を1日1回実行する CloudWatch イベントルール
# CloudWatch Event Rule to trigger Lambda once per day
resource "aws_cloudwatch_event_rule" "daily_lambda_trigger" {
  name                = "DailyLambdaTrigger"
  description         = "Trigger Lambda function once per day / Lambda 関数を1日1回トリガー"
  schedule_expression = "rate(1 day)"
}

# CloudWatch Events が Lambda 関数を実行できるようにする権限
# Permission to allow CloudWatch Events to invoke the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch_to_invoke" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scriptkitty_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_lambda_trigger.arn
}

# Lambda 関数を CloudWatch イベントルールに関連付け
# Attach the Lambda function to the CloudWatch Event Rule
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_lambda_trigger.name
  target_id = "lambda"
  arn       = aws_lambda_function.scriptkitty_lambda_function.arn
}
