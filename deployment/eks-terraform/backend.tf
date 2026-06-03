terraform {
  backend "s3" {
    bucket         = "naveen-eks-tf-state"
    key            = "us-east-1/terraform-useast1.tfstate"
    region         = "ap-south-1"
    dynamodb_table  = "terraform-state-lock-table"
  }
}
