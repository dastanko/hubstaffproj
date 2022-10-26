resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.key_path)
}

resource "aws_launch_template" "app_server_lt" {
  name          = "app_server_lt"
  image_id      = var.app_image_id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.id

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_server_sg.id]
  }

  user_data = filebase64("${path.module}/init.sh")

  tags = {
    Name = "AppServer"
  }
}


resource "aws_autoscaling_group" "app_server_asg" {
  name                = "AppServerAutoScalingGroup"
  max_size            = 3
  min_size            = 1
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  target_group_arns   = [aws_lb_target_group.app_server_lbtg.arn]

  launch_template {
    id      = aws_launch_template.app_server_lt.id
    version = "$Latest"
  }

}

resource "aws_autoscaling_policy" "app_server_asgp" {
  name                   = "AppServerAutoScalingPolicy"
  autoscaling_group_name = aws_autoscaling_group.app_server_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50
  }
}

