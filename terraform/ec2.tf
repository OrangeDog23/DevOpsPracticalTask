data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_launch_template" "testPracticalTask" {
  name_prefix   = "testPracticalTask"
  image_id      = var.asg_ami_id
  instance_type = "t2.micro"
}

resource "aws_launch_configuration" "testPracticalTask" {
  name_prefix   = "testPracticalTask-instance-"
  image_id      = var.asg_ami_id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.testPracticalTask.name
  key_name = aws_key_pair.jenkins_key.key_name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "testPracticalTask" {
  name                      = "testPracticalTask"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 3000000
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.az_private.id]
  target_group_arns = [aws_lb_target_group.testPracticalTask.arn]
  launch_configuration = aws_launch_configuration.testPracticalTask.name

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "ASG testPracticalTask"
    propagate_at_launch = true
  }
}

# jenkins deployment

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = var.jenkins_key
}

resource "aws_security_group" "testPracticalTask_jenkins_sg" {
  name        = "testPracticalTask-jenkins-sg"
  description = "Allow Http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = var.allowed_ip
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_ip
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [aws_subnet.az_public.cidr_block]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.jenkins_key.key_name
  subnet_id = aws_subnet.az_public.id
  associate_public_ip_address = true
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.testPracticalTask_jenkins.name
  vpc_security_group_ids = [aws_security_group.testPracticalTask_jenkins_sg.id]
  user_data = <<EOF
#!/bin/bash
sudo echo "APT::Acquire::Retries \"3\";" > /etc/apt/apt.conf.d/80-retries
sudo apt-get update
sudo apt-get install openjdk-8-jre -y
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install  awscli python3-pip unzip python-urllib3 -y
pip3 install flask waitress
cd /tmp && wget --quiet ${var.packer_url} && unzip packer*.zip && sudo cp ./packer /usr/bin && rm ./packer*
cd /tmp && wget --quiet ${var.terraform_url} && unzip terraform*.zip && sudo cp ./terraform /usr/bin && rm ./terraform*
apt-get install jenkins -y
EOF
  tags = {
    Name = "Jenkins"
  }
  depends_on = [aws_internet_gateway.public, aws_route_table_association.public]
}
