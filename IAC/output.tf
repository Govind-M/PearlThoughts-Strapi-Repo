output "vpc_id" {
  value       = data.aws_vpc.default.id
  description = "ID of the default VPC"
}
