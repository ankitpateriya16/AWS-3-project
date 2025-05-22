provider "aws" {
  region = var.region
}

# Using local backend
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# terraform {
#   backend "s3" {
#     bucket         = "my-backend-devops101-terraform"
#     key            = "tfstate/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     #dynamodb_table = "terraform-lock-table"
#   }
# }
