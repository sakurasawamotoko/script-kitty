# Terraformバックエンド設定 (Terraform backend configuration)
# nyankoronikki（Fargate bot）用に状態をS3に保存
# Lambda用のにゃんころとは異なるkeyを使用

terraform {
  backend "s3" {
    bucket         = "scriptkitty-terraform-state-bucket"  # 既存のバケットを共通使用 (use existing bucket)
    key            = "nyankoronikki/terraform.tfstate"      # Fargate専用の状態ファイルパス (unique path)
    region         = "ap-northeast-1"                       # 東京リージョン (Tokyo region)
    dynamodb_table = "scriptkitty-terraform-lock"           # 同じDynamoDBでロック管理 (same table for state locking)
    encrypt        = true                                   # S3に保存する状態を暗号化 (encrypt state)
  }
}
