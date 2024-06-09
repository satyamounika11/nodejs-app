output "ecs_cluster_id" {
  description = "The ECS Cluster ID"
  value       = aws_ecs_cluster.nodejs_cluster.id
}

output "ecs_service_name" {
  description = "The ECS Service Name"
  value       = aws_ecs_service.nodejs_service.name
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.nodejs_lb.dns_name
}

output "nat_gateway_id" {
  description = "The NAT Gateway ID"
  value       = aws_nat_gateway.nat_gateway.id
}

