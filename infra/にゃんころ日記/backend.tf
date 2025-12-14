# Terraform state backend
terraform {
  backend "s3" {
    bucket  = "scriptkitty-terraform-state-bucket"
    key     = "scriptkitty/nyankoronikki/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
    dynamodb_table = "scriptkitty-terraform-state-lock"
  }
}
