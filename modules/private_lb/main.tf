
resource "aws_lb" "private_alb" {
  name               = var.lb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.lb_sg
  subnets            = var.lb_private_subnets_ids
}
resource "aws_lb_target_group" "private_tg" {
  name     = "private-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "private_listener" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "backend_attachments" { 
  for_each          = var.private_instance_ids
  target_group_arn  = aws_lb_target_group.private_tg.arn
  target_id         = each.value
  port              = 80
}
