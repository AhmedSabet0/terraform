resource "aws_instance" "public_ec2_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = var.security_groups
  count           = length(var.public_subnets)
  subnet_id       = var.public_subnets[count.index]
  key_name        = var.key_name

  tags = {
    Name = "ec2_proxy_${count.index + 1}"
  }
   connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"                # Adjust based on your AMI (e.g., ubuntu for Ubuntu AMIs)
    private_key = file("D:/project/terraform/terraform_project/key.pem")
    timeout     = "1m"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo systemctl enable --now nginx",
      "sudo touch /etc/nginx/conf.d/reverse-proxy.conf",
      "sudo bash -c 'cat > /etc/nginx/conf.d/reverse-proxy.conf' << EOF",
      "server {",
      "    listen 80;",
      "    server_name _;",
      "    location / {",
      "        proxy_pass http://${var.private_alb_dns_name};",
      "        proxy_set_header Host \\$host;",
      "        proxy_set_header X-Real-IP \\$remote_addr;",
      "        proxy_set_header X-Forwarded-For \\$proxy_add_x_forwarded_for;",
      "        proxy_set_header X-Forwarded-Proto \\$scheme;",
      "    }",
      "}",
      "EOF",
      "sudo systemctl restart nginx"
    ]
  }
}


resource "aws_instance" "private_ec2_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = var.security_groups
  count           = length(var.private_subnets)
  subnet_id       = var.private_subnets[count.index]
  key_name        = var.key_name
  user_data = templatefile("modules/ec2/scripts/private_us-east-1a.sh.tpl",
  {
       backend_number = count.index + 1
  })
  
  tags = {
    Name = "ec2_backend_${count.index + 1}"
  }
}
