variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-south-1"
}

variable "ecs_task_execution_role_name" {
  description = "The name of the ECS task execution role"
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "existing_lb_security_group_id" {
  description = "The ID of the existing load balancer security group"
  type        = string
  default     = "sg-05f96394003ab9620"
}

variable "existing_ecs_security_group_id" {
  description = "The ID of the existing ECS security group"
  type        = string
  default     = "sg-09ffc812bc79e134b"
}

variable "subnet_id_for_nat_gateway" {
  description = "The subnet ID where the NAT gateway will be created"
  type        = string
  default     = "subnet-06356802f2a497660"
}

variable "private_route_table_id" {
  description = "The route table ID for private subnets"
  type        = string
  default     = "rtb-0e7ed776d67570ca3"
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = "vpc-0d24953f4e5a823c2"
}

variable "nodejs_image" {
  description = "The Docker image for the Node.js app"
  type        = string
  default     = "819821926402.dkr.ecr.ap-south-1.amazonaws.com/nodejs-app:latest"
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = ["subnet-058ec1ec7e81f6d43", "subnet-0e91e22e95bed1f3f"]
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = ["subnet-06356802f2a497660", "subnet-0532f087320986039"]
}

