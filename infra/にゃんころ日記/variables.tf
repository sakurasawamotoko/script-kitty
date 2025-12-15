# ネコ日記用のECRコンテナURI
# ECR image URI for nyankoronikki container
variable "container_image" {
  type        = string
  description = "ネコ日記用のECRコンテナURI / ECR image URI for nyankoronikki container"
}

# OpenAI APIキー（LLM用）
# OpenAI API key for LLM
variable "openai_api_key" {
  type        = string
  description = "OpenAI APIキー（LLM用） / OpenAI API key for LLM"
  sensitive   = true
}

# Pinecone APIキー（ベクトルDB用）
# Pinecone API key for vector database
variable "pinecone_api_key" {
  type        = string
  description = "Pinecone APIキー（ベクトルDB用） / Pinecone API key for vector database"
  sensitive   = true
}

# Pinecone環境（リージョン）
# Pinecone environment (region)
variable "pinecone_environment" {
  type        = string
  description = "Pinecone環境（リージョン） / Pinecone environment (region)"
}

variable "discord_bot_token" {
  type        = string
  description = "Discord bot token"
  sensitive   = true
}

variable "discord_guild_id" {
  type        = string
  description = "Discord guild ID"
  sensitive   = true
}