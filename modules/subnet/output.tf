output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}
output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}