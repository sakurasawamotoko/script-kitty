provider "aws" {
  region = "ap-northeast-1"
}

# ECR Repository to store the Docker image
resource "aws_ecr_repository" "scriptkitty_repo" {
  name = "scriptkitty-repo"
}

# Build the Docker image and push to ECR
resource "null_resource" "build_and_push" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.scriptkitty_repo.repository_url}
      docker build -t ${aws_ecr_repository.scriptkitty_repo.repository_url}:latest .
      docker push ${aws_ecr_repository.scriptkitty_repo.repository_url}:latest
    EOT
  }
  depends_on = [aws_ecr_repository.scriptkitty_repo]
}

# Lambda function using the Docker image
resource "aws_lambda_function" "scriptkitty_lambda" {
  function_name = "scriptkitty-docker-lambda"
  image_uri     = "${aws_ecr_repository.scriptkitty_repo.repository_url}:latest"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  ]
}