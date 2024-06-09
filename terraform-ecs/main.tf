provider "aws" {
  region = "ap-south-1"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_security_group" "existing_lb_security_group" {
  id = "sg-05f96394003ab9620"
}

data "aws_security_group" "existing_ecs_security_group" {
  id = "sg-09ffc812bc79e134b"
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = "subnet-06356802f2a497660" # Ensure this is a public subnet
}

resource "aws_route" "public_route" {
  route_table_id         = "rtb-0263dbb6534b25297"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "igw-0829d8a3ebcb44366"
}

resource "aws_route" "private_route" {
  route_table_id         = "rtb-0e7ed776d67570ca3"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_ecs_cluster" "nodejs_cluster" {
  name = "nodejs-cluster"
}

resource "aws_ecs_task_definition" "nodejs_task" {
  family                   = "nodejs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "nodejs-container"
    image     = "819821926402.dkr.ecr.ap-south-1.amazonaws.com/nodejs-app:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

resource "aws_ecs_service" "nodejs_service" {
  name            = "nodejs-service"
  cluster         = aws_ecs_cluster.nodejs_cluster.id
  task_definition = aws_ecs_task_definition.nodejs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-058ec1ec7e81f6d43", "subnet-0e91e22e95bed1f3f"]  # Private subnets
    security_groups = [data.aws_security_group.existing_ecs_security_group.id]
  }
}

resource "aws_lb" "nodejs_lb" {
  name               = "nodejs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.existing_lb_security_group.id]
  subnets            = ["subnet-06356802f2a497660", "subnet-0532f087320986039"] # Public subnets
}

resource "aws_lb_target_group" "nodejs_tg" {
  name     = "nodejs-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-0d24953f4e5a823c2"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "nodejs_listener" {
  load_balancer_arn = aws_lb.nodejs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nodejs_tg.arn
  }
}

