output "public_instance_ids" {
  value = { for k, v in aws_instance.public_ec2_instance : k => v.id }
}

output "private_instance_ids" {
  value = { for k, v in aws_instance.private_ec2_instance : k => v.id }
}