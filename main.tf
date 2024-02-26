provider "aws" {
  region     = "ap-southeast-1"
  access_key = "aaa"
  secret_key = "aaa"
}


# 1. Create vpc

resource "aws_vpc" "prod-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "production"
  }
}


# 2. Create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}


# 3. Create a Custom Route Table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod"
  }
}


# 4. Create a subnet

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "prod-subnet"
  }
}


# 5. Associate subnet with route table

resource "aws_route_table_association" "a" {

  subnet_id      =  aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id

}


# 6. Create security group

resource "aws_security_group" "ubuntu" {
  name        = "ubuntu"
  description = "Allow from the workstation to the ubuntu server on port 80"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["176.230.111.52/32"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["176.230.111.52/32"]
  }

ingress {
  description      = "Internal communication within the subnet"
  from_port        = 0
  to_port          = 0  
  protocol         = "-1"  
  cidr_blocks      = ["192.168.1.0/24"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_ubuntu"
  }
}


# 7. Create a network interface with an ip in the subnet what was created in step 4

resource "aws_network_interface" "ubuntu-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["192.168.1.11"]
  security_groups = [aws_security_group.ubuntu.id]

}


# 8. Create Ubuntu servers 

# Ubuntu Instance

resource "aws_instance" "ubuntu" {
  ami                  = "ami-03caf91bb3d81b843"
  instance_type        = "t2.micro"
  availability_zone    = "ap-southeast-1a"
  key_name             = "pkey"
  root_block_device {
    volume_size = 30  
  }
  network_interface {
    device_index          = 0
    network_interface_id  = aws_network_interface.ubuntu-nic.id
  }
  tags = {
    Name = "ubuntu"
  }
}

# Ubuntu Elastic IP

resource "aws_eip" "ubuntu-eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.ubuntu-nic.id
  associate_with_private_ip = "192.168.1.11"
  depends_on = [aws_internet_gateway.gw, aws_instance.ubuntu]

  tags = {
    Name = "ubuntu"
  }
}


