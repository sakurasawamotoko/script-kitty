# FargateサービスARN (ARN of the nyankoronikki Fargate service)
output "fargate_service_arn" {
  description = "ARN of the nyankoronikki Fargate service"
  value       = aws_ecs_service.nyankoronikki_service.arn
}

# Fargateタスク定義ARN (ARN of the Fargate task definition)
output "fargate_task_definition" {
  description = "ARN of the nyankoronikki Fargate task definition"
  value       = aws_ecs_task_definition.nyankoronikki_task.arn
}

# ECSクラスター名 (Name of the ECS cluster)
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.nyankoronikki.name
}
