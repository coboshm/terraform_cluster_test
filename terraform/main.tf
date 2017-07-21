
provider "aws" {
  region = "us-east-1"
}

resource "aws_elb" "example" {
  name = "terraform-api-example"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-api-example-elb"

  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = "${var.max_size}"
  max_size = "${var.min_size}"

  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-api-example"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "example" {
  # Ubuntu Server 14.04 LTS (HVM), SSD Volume Type in us-east-1
  image_id = "ami-2d39803a"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]

  # Provision the instances with the binary of the api
  provisioner "api_binary" {
    source      = "build/api"
    destination = "/opt/api"
  }

  #Start binary TODO: Create service and start it
  user_data = <<-EOF
              #!/bin/bash
              nohup ./opt/api &
              EOF

  # Important note: whenever using a launch configuration with an auto scaling group, you must set
  # create_before_destroy = true.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-api-example-instance"

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

