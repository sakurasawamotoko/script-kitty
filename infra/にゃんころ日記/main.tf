# ネコ日記用のAWSプロバイダー
# AWS provider for nyankoronikki
provider "aws" {
  region = "ap-northeast-1" # 東京リージョン
}

# ネコ日記用ECSクラスター
# ECS cluster for nyankoronikki
resource "aws_ecs_cluster" "nyankoronikki" {
  name = "nyankoronikki-cluster"
}

# ネコ日記用IAMロール
# IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "nyankoronikki-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ECSタスク実行用ポリシー（ECRへのアクセス許可を追加）
resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = "nyankoronikki-ecs-task-execution-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# ECSタスク定義
# ECS task definition
resource "aws_ecs_task_definition" "nyankoronikki" {
  family                   = "nyankoronikki-task"
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nyankoronikki-container"
      image     = var.container_image
      cpu       = 512
      memory    = 1024
      essential = true
      environment = [
        { name = "OPENAI_API_KEY", value = var.openai_api_key },
        { name = "PINECONE_API_KEY", value = var.pinecone_api_key },
        { name = "PINECONE_ENVIRONMENT", value = var.pinecone_environment }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/nyankoronikki"
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ECSサービス
# ECS service
resource "aws_ecs_service" "nyankoronikki" {
  name            = "nyankoronikki-service"
  cluster         = aws_ecs_cluster.nyankoronikki.id
  task_definition = aws_ecs_task_definition.nyankoronikki.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    subnets = [
      "subnet-0f00c572a0b838597",  # ap-northeast-1a
      "subnet-01445006ae2805432",  # ap-northeast-1c
      "subnet-04cbf560e48473065"   # ap-northeast-1d
    ]
    security_groups = [
      "sg-0a978c481fdd7e06f"  # nyankoronikki-ecs-sg
    ]
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
}
