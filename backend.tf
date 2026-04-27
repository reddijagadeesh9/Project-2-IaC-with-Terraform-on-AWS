terraform {
  backend "s3" {
    bucket         = "jagadeesh-terraform-state-12345"
    key            = "dev/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock"
  }
}
