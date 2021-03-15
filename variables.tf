variable key_name {
    default = "ec2-key"
}

variable public_key {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

variable vpc_cidr_block {
    default = "10.0.0.0/16"
}

variable instance_tenancy {
    default = "default"
}

variable enable_dns_support {
    default = "true"
}

variable enable_dns_hostnames {
    default = "true"
}

variable bastion_cidr_block {
    default = "10.0.1.0/24"
}

variable map_public_ip_on_launch {
    default = "true"
}

variable bastion_subnet_tag_name {
    default = "bastion-subnet"
}

variable backend_subnet_tag_name {
    default = "backend-subnet"
}

variable frontend_cidr_block {
    default = "10.0.2.0/24"
}

variable frontend_subnet_tag_name {
    default = "frontend-subnet"
}

variable backend_cidr_block {
    default = "10.0.3.0/24"
}

variable internet_gateway_tag_name {
    default = "my-igw"
}

variable rt_sg_cidr_block {
    default = "0.0.0.0/0"
}

variable route_table_tag_name {
    default = "route-table"
}

variable bastion_sg_name {
    default = "bastion-sg"
}

variable sg_description {
    default = "Allow SSH/TLS traffic"
}

variable ssh_port {
    default = "22"
}

variable protocol {
    default = "tcp"
}

variable bastion_ingress_cidr_block {
    default = "100.68.0.0/18"
}

variable bastion_sg_tag_name {
    default = "bastion-sg"
}

variable frontend_sg_name {
    default = "frontend-sg"
}

variable frontend_sg_tag_name {
    default = "frontend-sg"
}

variable https_port {
    default = "443"
}

variable http_port {
    default = "80"
}

variable backend_sg_name {
    default = "backend-sg"
}

variable backend_sg_tag_name {
    default = "backend-sg"
}

variable ec2_ami {
    default = "ami-04169656fea786776"
}

variable ec2_instance_type {
    default = "t2.nano"
}

variable ec2_key_name {
    default = "ec2-key"
}

variable associate_public_ip_address {
    default = "true"
}

variable bastion_ec2_tag_name {
    default = "bastion-host"
}

variable frontend_ec2_tag_name {
    default = "frontend-host"
}

variable backend_ec2_tag_name {
    default = "backend-host"
}

variable ingress_rule {
    default = "ingress"
}

variable egress_rule {
    default = "egress"
}