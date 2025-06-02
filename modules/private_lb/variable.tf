variable "lb_name" {
  type        = string
}

variable "lb_sg" {
type = list(string)

}

variable "vpc_id" {
  type = string
}

variable "private_instance_ids" {
  type = map(string)
}
variable "lb_private_subnets_ids" {
  type = list(string)
}