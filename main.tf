module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  project_name = "MY_vpc"
}

module "subnet" {
  source               = "./modules/subnet"
  vpc_id               = module.vpc.vpc_id
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnets
  private_subnet_cidrs = var.private_subnets

}

module "proxy_sg" {
  source      = "./modules/sg"
  name        = "proxy-sg"
  description = "Proxy EC2 SG"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description     = "Allow HTTP from Public ALB"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    },
    {
      description     = "Allow HTTPS from internet"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
     },
     {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ]

egress_rules = [
  {
    description     = "Allow all outbound traffic"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = []
  }
]

  tags = {
    Name = "proxy-sg"
   }
}

module "backend_sg" {
  source      = "./modules/sg"
  name        = "backend-sg"
  description = "Backend EC2 SG"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description     = "Allow HTTP from proxy"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [module.proxy_sg.sg] # Reference to proxy SG
    }
  ]

egress_rules = [
 {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

  tags = {
    Name = "backend-sg"
  }
}

module "ec2" {
  source          = "./modules/ec2"
  ami_id          = var.ec2_ami_id
  instance_type   = var.ec2_instance_type
  public_subnets  = module.subnet.public_subnet_ids
  private_subnets = module.subnet.private_subnet_ids
  private_alb_dns_name = module.private_lb.private_alb_dns_name
  security_groups = [module.proxy_sg.sg]
  key_name        = var.key_name
}

module "public_lb" {
  source                 = "./modules/public_lb"
  lb_name                = "public-lb"
  lb_sg                  = [module.proxy_sg.sg]
  lb_public_subnets_ids  = module.subnet.public_subnet_ids
  vpc_id   = module.vpc.vpc_id
  proxy_instance_ids     = values(module.ec2.public_instance_ids)

}

module "private_lb" {
  source                 = "./modules/private_lb"
  lb_name                = "private-lb"
  lb_sg                  = [module.backend_sg.sg]
  lb_private_subnets_ids = module.subnet.private_subnet_ids
  vpc_id   = module.vpc.vpc_id
  private_instance_ids = module.ec2.private_instance_ids
}
