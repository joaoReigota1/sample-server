provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Checkmarx"
      Project     = "Server"
    }
  }
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "instance" {
  name        = "ec2-sgr"
  description = "security group for ec2 instance"

  # kics-scan ignore-block
  ingress {
    description = "ec2 ingress"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ec2 egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "launch_server" {
  image_id      = "ami-0fc15d50d39e4503c"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.instance.id]

  user_data = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "server_auto_scaling" {
  launch_configuration = aws_launch_configuration.launch_server.id
  load_balancers       = [aws_elb.server_elb.name]
  availability_zones   = ["eu-west-2b", "eu-west-2a"]
  min_size             = 2
  max_size             = 5

  tag {
    key                 = "Name"
    value               = "go-simple-server"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "elb" {
  name        = "elb-sgr"
  description = "security group for elb instance"

  # kics-scan ignore-block
  ingress {
    description = "elb ingress"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "elb egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "server_elb" {
  name               = "go-simple-server"
  availability_zones = ["eu-west-2c", "eu-west-2a"]
  security_groups    = [aws_security_group.elb.id]

  access_logs {
    bucket        = "sample-server-log-bucket"
    bucket_prefix = "bar"
    interval      = 60
    enabled       = true
  }

  listener {
    lb_port           = 4000
    lb_protocol       = "http"
    instance_port     = 4000
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 60
    target              = "HTTP:4000/"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/setup.sh")
}


output "elb_dns_name" {
  description = "ELB DNS Name"
  value       = "${aws_elb.server_elb.dns_name}"
}