variable "aws-region" {
  default = "eu-west-1"
}

variable "base_cidr_block" {
  description = "A /16 CIDR range definition, such as 10.1.0.0/16, that the VPC will use"
  default = "172.16.0.0/16"
}

variable "availability_zone" {
  description = "A availability zone which used to create subnets"
  default = "eu-west-1a"
}

variable "availability_zone_2" {
  description = "another availability zone wich used to  to create subnets"
  default = "eu-west-1b"
}

variable "distro_name" {
  description = "Image from marketplace for creating ami image"
  default = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}

variable "distro_owners" {
  description = "Owners of image to search for"
  default = ["099720109477"]
}

