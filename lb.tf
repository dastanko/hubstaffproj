resource "aws_lb" "app_server_lb" {
  name               = "AppServerLB"
  internal           = false
  security_groups    = [aws_security_group.lb_sg.id]
  load_balancer_type = "application"
  subnets            = [aws_default_subnet.public_1.id, aws_default_subnet.public_2.id]

  tags = {
    Name = "app_server_lb"
  }
}

resource "aws_lb_target_group" "app_server_lbtg" {
  name        = "AppServerLBTargetGroup"
  vpc_id      = aws_default_vpc.default.id
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    timeout = 20
  }
}

resource "aws_lb_listener" "app_server_lb_listener" {
  load_balancer_arn = aws_lb.app_server_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.app_server_lbtg.arn
      }
    }
  }
}