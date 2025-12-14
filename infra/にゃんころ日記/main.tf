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

# ECSタスク用にECRアクセスとCloudWatchログ用ポリシーをアタッチ
# Attach managed policy to allow ECS tasks to pull from ECR and write logs
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_ecr" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/servi_
