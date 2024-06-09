provider "aws" {
  region = "ap-south-1"
}

resource "aws_ecs_cluster" "nodejs_cluster" {
  name = "nodejs-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

resource "aws_ecs_task_definition" "nodejs_task" {
  family                   = "nodejs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

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
    subnets         = ["subnet-06356802f2a497660", "subnet-0532f087320986039"]
    security_groups = ["sg-09ffc812bc79e134b"]
  }
}

resource "aws_lb" "nodejs_lb" {
  name               = "nodejs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-05f96394003ab9620"]
  subnets            = ["subnet-06356802f2a497660", "subnet-0532f087320986039"]
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

resource "aws_security_group" "lb_security_group" {
  name        = "nodejs-lb-security-group"
  description = "Allow HTTP traffic to the load balancer"
  vpc_id      = "vpc-0d24953f4e5a823c2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-security-group"
  description = "Allow traffic to ECS tasks"
  vpc_id      = "vpc-0d24953f4e5a823c2"

  ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups  = [aws_security_group.lb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

