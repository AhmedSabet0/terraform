terraform-lab/
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
├── terraform.tfvars
├── scripts/
│   ├── install_proxy.sh
│   └── install_apache.sh
└── modules/
    ├── vpc/
                main.tf        👈 resource "aws_vpc"
	        variables.tf   👈 vpc_cidr, project_name
	        outputs.tf     👈 vpc_id
    ├── subnet/
		main.tf        👈 resource "aws_subnet"
		variables.tf   👈 vpc_id, cidr_block, map_public_ip_on_launch, subnet_name, subnet_tier
		outputs.tf     👈 subnet_id
    ├── ec2/
		main.tf        👈 resource "aws_instance"
		variables.tf   👈 ami, instance_type, key_name, user_data, subnet_id, security_group_ids
		outputs.tf     👈 instance_id, private_ip, public_ip
    ├── sg/
		main.tf        👈 resource "aws_security_group"
		variables.tf   👈 name, vpc_id, ingress, egress rules
		outputs.tf     👈 security_group_id
    └── elb/
		main.tf        👈 resource "aws_lb" and aws_lb_target_group
		variables.tf   👈 name, subnets, security_groups, target_group config
		outputs.tf     👈 dns_name
