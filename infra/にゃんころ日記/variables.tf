# AWSリージョン (AWS Region)
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

# Fargateタスク用サブネットIDリスト (List of subnet IDs for Fargate tasks)
variable "subnets" {
  description = "List of subnet IDs for Fargate tasks"
  type        = list(string)
}

# Fargateタスク用セキュリティグループ (Security group for Fargate tasks)
variable "security_group" {
  description = "Security group ID for Fargate tasks"
  type        = string
}

# nyankoronikkiコンテナイメージ (Docker image URI)
variable "container_image" {
  description = "ECR image URI for nyankoronikki container"
  type        = string
}

# OpenAI APIキー (OpenAI API key)
variable "openai_api_key" {
  description = "OpenAI API key for bot"
  type        = string
  sensitive   = true
}

# Pinecone APIキー (Pinecone API key)
variable "pinecone_api_key" {
  description = "Pinecone API key for RAG"
  type        = string
  sensitive   = true
}
