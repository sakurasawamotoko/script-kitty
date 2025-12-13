provider "aws" {
  region = var.region
}

# ECSクラスター作成 (Create ECS Cluster)
resource "aws_ecs_cluster" "nyankoronikki" {
  name = "nyankoronikki-cluster"
}

# CloudWatchロググループ (CloudWatch log group for ECS)
resource "aws_cloudwatch_log_group" "nyankoronikki" {
  name              = "/ecs/nyankoronikki"
  retention_in_days = 30
}

# Fargateタスク実行用IAMロール (IAM Role for Fargate task execution)
resource "aws_iam_role" "fargate_exec" {
  name = "nyankoronikki-fargate-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Effect    = "Allow"
    }]
  })
}

# IAMロールにECS実行ポリシーをアタッチ (Attach ECS task execution policy)
resource "aws_iam_role_policy_attachment" "exec_policy" {
  role       = aws_iam_role.fargate_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Fargateタスク定義 (Fargate Task Definition)
resource "aws_ecs_task_definition" "nyankoronikki_task" {
  family                   = "nyankoronikki-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.fargate_exec.arn

  container_definitions = jsonencode([
    {
      name      = "nyankoronikki"
      image     = var.container_image
      essential = true
      # 環境変数 (Environment variables)
      environment = [
        { name = "OPENAI_API_KEY", value = var.openai_api_key },
        { name = "PINECONE_API_KEY", value = var.pinecone_api_key }
      ]
      # CloudWatchログ設定 (CloudWatch log configuration)
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.nyankoronikki.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# Fargateサービス (Fargate Service for 24/7 bot)
resource "aws_ecs_service" "nyankoronikki_service" {
  name            = "nyankoronikki-service"
  cluster         = aws_ecs_cluster.nyankoronikki.id
  task_definition = aws_ecs_task_definition.nyankoronikki_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group]
    assign_public_ip = true
  }

  # IAMロールポリシーの依存関係 (Ensure policy attachment exists before service)
  depends_on = [aws_iam_role_policy_attachment.exec_policy]
}
