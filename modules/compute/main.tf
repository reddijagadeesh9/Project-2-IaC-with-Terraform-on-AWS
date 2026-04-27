resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.ec2_sg_id]

  metadata_options {
    http_tokens = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-server"
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.public_subnet_id]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}


