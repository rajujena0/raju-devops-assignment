output "alb_dns_name" {
  description = "ALB DNS — use this as your app URL"
  value       = aws_lb.main.dns_name
}

output "ec2_instance_id" {
  description = "App server instance ID"
  value       = aws_instance.app.id
}

output "ec2_private_ip" {
  description = "App server private IP"
  value       = aws_instance.app.private_ip
}

output "rds_endpoint" {
  description = "PostgreSQL connection endpoint"
  value       = aws_db_instance.postgres.endpoint
  sensitive   = true
}

output "rds_db_name" {
  description = "PostgreSQL database name"
  value       = aws_db_instance.postgres.db_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}
