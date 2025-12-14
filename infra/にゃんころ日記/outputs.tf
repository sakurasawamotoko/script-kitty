# ECSクラスター名
# ECS cluster name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.nyankoronikki.name
}

# ECSサービス名
# ECS service name
output "ecs_service_name" {
  value = aws_ecs_service.nyankoronikki.name
}

# タスク定義ARN
# Task definition ARN
output "task_definition_arn" {
  value = aws_ecs_task_definition.nyankoronikki.arn
}
