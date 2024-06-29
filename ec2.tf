data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.app_key_pair.key_name

  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true  # If you want the instance to have a public IP

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data_replace_on_change = true 
  user_data = templatefile("${path.module}/files/user_data.sh", {
      app_name         = var.app_name,
      docker_compose   = file("${path.module}/files/docker-compose.yml")  # Add this line
  })

  tags = {
    Name = "${var.app_name}-instance"
  }
}

resource "aws_key_pair" "app_key_pair" {
  key_name   = "${var.app_name}-key"
  public_key = tls_private_key.app_key.public_key_openssh
}

resource "tls_private_key" "app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}