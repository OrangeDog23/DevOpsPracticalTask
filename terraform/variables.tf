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
  description = "another availability zone wich used to create subnets"
  default = "eu-west-1b"
}

variable "asg_ami_id" {
  description = "Ami for creating ASG"
  default = "ami-07042e91d04b1c30d"
}

variable "packer_url" {
  description = "Packer url for jenkins installation"
  default = "https://releases.hashicorp.com/packer/1.5.4/packer_1.5.4_linux_amd64.zip"
}

variable "terraform_url" {
  description = "terraform url for jenkins installation"
  default = "https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip"
}

variable "jenkins_key" {
  description = "key to access to jenkins instance"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/LN5daUw6oYkVlv/SQqLTJ1dC2O35RQMq7UmIHyCSU25RzAQiqYGPzYrnXJaYYMQn/kvawrwmAtnegKBp2+Tn1wWMx6jUlV6BMBCMWPKOrKZkaXIySnT/55y4/pu9jsfJYQ8KLiapit6eMyR0FX7X1PC04fF4QC4w2wr+F6XTW5+R+KMnyuVGV49RztPrBO3gGzr3bMF4cECnAtf0OQBHi94lfUkczAOmX0uNQOr4ynA5gZkCVivmpXE25+lt8Nff67AUXd6yhhJq2N4Zq0wBq0iIlkRMAhuBMG31D3lwuczUGrH+/3s8geQMVvnt5IQQfLhVCBLhampM5UTUGbEMyktpH+w+JPi/7c1x27tBEC6IbMOXlsZm3HkiIAt29wWnD8p8rQx2N5KR+KqtfOgJya0F4MRwGPxndH25jD7uJeYoevZCt5FNi1iGq4Yd48dyKM1+aOZaGGiQ9h1FhiSL9Ul6+9fVnJNpGGn2sPYO56Zq4uv72Sjj5rFH9KZBnvE= devops_test_user"
}

variable "allowed_ip" {
  description = "cidr blocks to allow access to jenkins and app via http:8080"
  default = ["95.106.216.10/32"]
}

