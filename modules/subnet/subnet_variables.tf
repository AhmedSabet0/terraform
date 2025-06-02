# modules/subnet/variables.tf
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type = list(string)
}
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type = list(string)
}
variable "vpc_id" {
  description = "VPC ID to associate the subnet with"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type = list(string)
}