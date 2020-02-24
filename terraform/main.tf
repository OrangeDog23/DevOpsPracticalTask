provider "aws" {
  region = var.aws-region
}

terraform {
  backend "s3" {
    bucket = "devopspracticaltask-bucket"
    key    = "DevOpsPracticalTask/key"
    region = "eu-west-1"
  }
}
