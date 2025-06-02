variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "security_groups" {
  description = "List of security groups for the EC2 instance"
type =   list(string)
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "private_alb_dns_name" {
  description = "DNS name of the private ALB"
  type        = string
}