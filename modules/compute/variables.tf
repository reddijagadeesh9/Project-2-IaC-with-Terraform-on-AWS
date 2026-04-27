variable "public_subnet_id" {
  type = string
}

variable "ec2_sg_id" {
  type = string
}

variable "ami_id" {
  type    = string
  default = "ami-0c1ac8a41498c1a9c"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
