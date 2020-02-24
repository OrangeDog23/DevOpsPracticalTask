resource "aws_security_group" "allow_http" {
  name        = "allow_access to http"
  vpc_id      = aws_vpc.main.id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "testPracticalTask" {
  name               = "testPracticalTask"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.az_public.id, aws_subnet.az_public_2.id]
  security_groups = [aws_security_group.allow_http.id]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "testPracticalTask" {
  name     = "testPracticalTask-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.testPracticalTask.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.testPracticalTask.arn
  }
}
