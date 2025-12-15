# logs.tf
resource "aws_cloudwatch_log_group" "nyankoronikki_service" {
  name              = "/ecs/nyankoronikki-service"
  retention_in_days = 14
}