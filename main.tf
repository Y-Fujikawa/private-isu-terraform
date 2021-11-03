# VPC
resource "aws_vpc" "private_isu_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.name}_vpc"
  }
}

# Public Subnet
resource "aws_subnet" "private_isu_public_subnet" {
  vpc_id            = aws_vpc.private_isu_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.name}_public_subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "private_isu_igw" {
  vpc_id = aws_vpc.private_isu_vpc.id

  tags = {
    Name = "${var.name}_igw"
  }
}

# Root Table
resource "aws_route_table" "private_isu_rt" {
  vpc_id = aws_vpc.private_isu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.private_isu_igw.id
  }

  tags = {
    Name = "${var.name}_rt"
  }
}

# Root Table Subnet
resource "aws_route_table_association" "private_isu_rt_assoc" {
  subnet_id      = aws_subnet.private_isu_public_subnet.id
  route_table_id = aws_route_table.private_isu_rt.id
}

# Security Group
resource "aws_security_group" "private_isu_sg" {
  name   = "private_isu_sg"
  vpc_id = aws_vpc.private_isu_vpc.id

  ingress {
    description = "TCP 80 Port from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # https://github.com/hakatashi/benchmarker-webapp を使ってアクセスする予定なので開けておく
  ingress {
    description = "TCP 3000 Port from Benchmark"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}_sg"
  }
}
