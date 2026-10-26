
provider "aws" {
  region = "ap-south-1"
}

# 1. Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Task4-VPC"
  }
}

# 2. Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Task4-Public-Subnet"
  }
}

# 3. Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Task4-Internet-Gateway"
  }
}

# 4. Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Task4-Public-Route-Table"
  }
}

# 5. Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 6. Your current public IP
variable "my_ip" {
  description = "Your public IPv4 address"
  type        = string
}

# 7. Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "Task4-EC2-Security-Group"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id

  # SSH access restricted to your IP
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  # HTTP access for website
  ingress {
    description = "Allow HTTP website traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Task4-EC2-Security-Group"
  }
}

# 8. EC2 Instance
resource "aws_instance" "web" {
  ami                         = "ami-0f5ee92e2d63afc18"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = "Task4-Key"
  associate_public_ip_address = true

  tags = {
    Name = "Task4-EC2-Instance"
  }
}

# 9. Output EC2 Public IP
output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}
