terraform {
  backend "s3" {
    bucket         = "naveen-eks-tf-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table  = "terraform-state-lock-table"
  }
}
