output "vpc_id" {
  value       = data.aws_vpc.default.id
  description = "ID of the default VPC"
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.strapi_repository.repository_url
  description = "URL of the ECR repository"
}

output "ecs_cluster_id" {
  value       = aws_ecs_cluster.strapi_cluster.id
  description = "ID of the ECS cluster"
}


output "ecs_service_id" {
  value       = aws_ecs_service.strapi_service.id
  description = "ID of the ECS service"
}

output "alb_dns_name" {
  value = aws_lb.strapi.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.strapi_postgres.address
}