provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0583d8c7a9c35822c" # Use the appropriate AMI ID
  instance_type = "t2.micro"
  key_name      = "devops_practice"
  tags = {
    Name = "Ec2InstancebyUdayP-nv"
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = ["subnet-0bafc53fc735aca50"] # Replace with your subnet ID
  name                = "asg-UdayP-NV"
  #launch_configuration = aws_launch_configuration.lc.id
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "lt" {
  image_id      = "ami-0583d8c7a9c35822c"
  instance_type = "t2.micro"
  key_name      = "devops_practice"
}

resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0bafc53fc735aca50", "subnet-078415a77a386ad3e"]
}

resource "aws_route53_record" "dns" {
  zone_id = "Z09913613N7FKP7GQVGOB" # Replace with your Route 53 hosted zone ID
  name    = "samsorzone100.com"
  type    = "A"

  alias {
    name                   = aws_lb.my_lb.dns_name
    zone_id                = aws_lb.my_lb.zone_id
    evaluate_target_health = false
  }
}
