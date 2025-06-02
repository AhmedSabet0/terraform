
resource "aws_lb" "public_alb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_sg
  subnets            = var.lb_public_subnets_ids
}
resource "aws_lb_target_group" "public_tg" {
  name     = "public-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "public_listener" { 
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }
}


resource "aws_lb_target_group_attachment" "proxy_attachments" { 
  count             = length(var.proxy_instance_ids)
  target_group_arn  = aws_lb_target_group.public_tg.arn
  target_id         = var.proxy_instance_ids[count.index]
  port              = 80
}
