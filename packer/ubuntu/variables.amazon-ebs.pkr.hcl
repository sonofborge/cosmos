locals {
  subnet_id = "subnet-064852bb25d9bc77a" # Alpheratz-VPC Public 1
  vpc_id    = "vpc-0d398105a81111c53"    # Alpheratz-VPC
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
