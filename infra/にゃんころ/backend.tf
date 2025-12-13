terraform {
  backend "s3" {
    bucket         = "scriptkitty-terraform-state-bucket"
    key            = "scriptkitty/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
}