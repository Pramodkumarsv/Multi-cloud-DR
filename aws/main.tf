resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "app" {
  ami             = "ami-04b4f1a9cf54c11d0"  # Use latest Ubuntu AMI
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_1.id
  security_groups = [aws_security_group.web_sg.name]
  key_name        = aws_key_pair.keypair.key_name
  tags = { Name = "App Machine" }
}

resource "aws_instance" "tools" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_2.id
  security_groups = [aws_security_group.web_sg.name]
  key_name        = aws_key_pair.keypair.key_name
  tags = { Name = "Tools Machine" }
}
