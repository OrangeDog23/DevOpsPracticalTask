data "aws_ami" "testPracticalTask" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.distro_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = var.distro_owners
}


resource "aws_launch_template" "testPracticalTask" {
  name_prefix   = "testPracticalTask"
  image_id      = data.aws_ami.testPracticalTask.id
  instance_type = "t2.micro"
}

resource "aws_launch_configuration" "testPracticalTask" {
  name_prefix   = "testPracticalTask-instance-"
  image_id      = data.aws_ami.testPracticalTask.id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.testPracticalTask.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "testPracticalTask" {
  name                      = "testPracticalTask"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.az_private.id]
  target_group_arns = [aws_lb_target_group.testPracticalTask.arn]

  launch_template {
    id      = aws_launch_template.testPracticalTask.id
    version = "$Latest"
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "testPracticalTask_tag"
    value               = "tag_value"
    propagate_at_launch = false
  }
}
