variable "vpc_cidr" {
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type = list(string)

}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type = list(string)

}

variable "ec2_instance_type" {

  type        = string
}

variable "ec2_ami_id" {

  type        = string
}
variable "key_name" {

  type        = string
}

variable "availability_zones" {
  description = "List of AZs to use for subnets"
  type = list(string)

}