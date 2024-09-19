terraform {
  backend "s3" {
    bucket         = "shoppr-remote-backend"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "shoppr-tfstate-locking"
    encrypt        = true
  }
}