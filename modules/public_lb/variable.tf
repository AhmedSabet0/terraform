variable "lb_name" {
  type        = string
}

variable "lb_sg" {
  type = list(string)

}

variable "vpc_id" {
  type = string
}

variable "proxy_instance_ids" {
  type = list(string)
}
variable "lb_public_subnets_ids" {
  type = list(string)
}