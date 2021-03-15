# Create a key pair
resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = var.public_key
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "myVPC"
  }
}

# Create a subnet for bastion host
resource "aws_subnet" "bastion" {
  vpc_id                  =    aws_vpc.main.id
  cidr_block              =    var.bastion_cidr_block
  map_public_ip_on_launch =    var.map_public_ip_on_launch
  tags = {
    Name = var.bastion_subnet_tag_name
  }
  depends_on = ["aws_vpc.main"]
}

# Create a subnet for frontend host
resource "aws_subnet" "frontend" {
  vpc_id                  =    aws_vpc.main.id
  cidr_block              =    var.frontend_cidr_block
  map_public_ip_on_launch =    var.map_public_ip_on_launch
  tags = {
    Name = var.frontend_subnet_tag_name
  }
  depends_on = ["aws_vpc.main"]
}

# Create a subnet for backend host
resource "aws_subnet" "backend" {
  vpc_id                  =    aws_vpc.main.id
  cidr_block              =    var.backend_cidr_block
  map_public_ip_on_launch =    var.map_public_ip_on_launch
  tags = {
    Name = var.backend_subnet_tag_name
  }
  depends_on = ["aws_vpc.main"]
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = var.internet_gateway_tag_name
    }
}

# Create a Route Table
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block = var.rt_sg_cidr_block
        gateway_id = aws_internet_gateway.igw.id
    }
    
    tags = {
        Name = var.route_table_tag_name
    }
}

# Associate Frontend Subnet with Route Table
resource "aws_route_table_association" "frontend-subnet"{
    subnet_id = aws_subnet.frontend.id
    route_table_id = aws_route_table.rt.id
}

# Create security group for bastion ec2 instance
resource "aws_security_group" "bastion" {
  name          = var.bastion_sg_name
  description   = var.sg_description
  vpc_id        = aws_vpc.main.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = [var.bastion_ingress_cidr_block]
  }

  egress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = ["${aws_instance.frontend.private_ip}/32"]
  }

  egress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = ["${aws_instance.backend.private_ip}/32"]
  }

  tags = {
    Name = var.bastion_sg_tag_name
  }
  depends_on    = ["aws_instance.frontend", "aws_instance.backend"]
}

# Create security group for frontend ec2 instance
resource "aws_security_group" "frontend" {
  name        = var.frontend_sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = var.protocol
    cidr_blocks = [var.rt_sg_cidr_block]
  }

  tags = {
    Name = var.frontend_sg_tag_name
  }
}

# Create security group for backend ec2 instance
resource "aws_security_group" "backend" {
  name        = var.backend_sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = var.frontend_sg_tag_name
  }
}

# Create bastion ec2 instance
resource "aws_instance" "bastion" {
	ami             =    var.ec2_ami
  instance_type   =    var.ec2_instance_type
	key_name        =    var.key_name
	subnet_id       =    aws_subnet.bastion.id
  security_groups =    [aws_security_group.bastion.id]
  associate_public_ip_address = var.associate_public_ip_address
	tags = {
        Name = var.bastion_ec2_tag_name
    }
    depends_on = ["aws_subnet.bastion", "aws_security_group.bastion"]
}

# Create frontend ec2 instance
resource "aws_instance" "frontend" {
	ami             =    var.ec2_ami
  instance_type   =    var.ec2_instance_type
	key_name        =    var.key_name
	subnet_id       =    aws_subnet.frontend.id
  security_groups =    [aws_security_group.frontend.id]
  user_data       =    "${file("user-data.sh")}"
  associate_public_ip_address = var.associate_public_ip_address
	tags = {
        Name = var.frontend_ec2_tag_name
    }
    depends_on = ["aws_subnet.frontend", "aws_security_group.frontend"]
}

# Create backend ec2 instance
resource "aws_instance" "backend" {
	ami             =    var.ec2_ami
  instance_type   =    var.ec2_instance_type
	key_name        =    var.key_name
	subnet_id       =    aws_subnet.backend.id
  security_groups =    [aws_security_group.backend.id]
  user_data       =    "${file("user-data.sh")}"
  associate_public_ip_address = var.associate_public_ip_address
	tags = {
        Name = var.backend_ec2_tag_name
    }
    depends_on = ["aws_subnet.backend", "aws_security_group.backend"]
}

# Add Ingress Rules for frontend Security Group
resource "aws_security_group_rule" "frontend1" {
  type              = var.ingress_rule
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = var.protocol
  cidr_blocks       = ["${aws_instance.bastion.private_ip}/32"]
  security_group_id = aws_security_group.frontend.id
  depends_on        = ["aws_instance.backend"]
}

# Add Ingress Rules for frontend Security Group
resource "aws_security_group_rule" "frontend2" {
  type              = var.egress_rule
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = var.protocol
  cidr_blocks       = ["${aws_instance.backend.public_ip}/32"]
  security_group_id = aws_security_group.frontend.id
  depends_on        = ["aws_instance.backend"]
}

# Add Ingress Rule for backend Security Group
resource "aws_security_group_rule" "backend1" {
  type              = var.ingress_rule
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = var.protocol
  cidr_blocks       = ["${aws_instance.bastion.private_ip}/32"]
  security_group_id = aws_security_group.backend.id
  depends_on        = ["aws_instance.bastion"]
}

# Add Egress Rule for backend Security Group
resource "aws_security_group_rule" "backend2" {
  type              = var.ingress_rule
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = var.protocol
  cidr_blocks       = ["${aws_instance.frontend.public_ip}/32"]
  security_group_id = aws_security_group.backend.id
  depends_on        = ["aws_instance.frontend"]
}