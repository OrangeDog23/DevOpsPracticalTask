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

resource "aws_placement_group" "testPracticalTask" {
  name     = "testPracticalTask"
  strategy = "cluster"
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
  placement_group           = aws_placement_group.testPracticalTask.id
  vpc_zone_identifier       = [aws_subnet.az_private.id]

  initial_lifecycle_hook {
    name                 = "testPracticalTask"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = <<EOF
{
  "foo": "bar"
}
EOF
    role_arn                = aws_iam_role.testPracticalTask.arn
  }

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
