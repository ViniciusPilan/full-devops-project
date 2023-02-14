terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}


# S3 Bucket -----------------------------------------------------
## Bucket
resource "aws_s3_bucket" "bucket_web_server" {
  bucket = var.bucket_name
  tags = {
    Name = "bucket-images-web-server"
  }
}

resource "aws_s3_bucket_policy" "allow_access_to_images" {
  bucket = aws_s3_bucket.bucket_web_server.id
  policy = data.aws_iam_policy_document.allow_access_to_images.json
}

data "aws_iam_policy_document" "allow_access_to_images" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.bucket_web_server.arn,
      "${aws_s3_bucket.bucket_web_server.arn}/*",
    ]
  }
}

## Bucket Policy


# Web Server ----------------------------------------------------
## EC2 Key Pair
resource "aws_key_pair" "web_server_kp" {
  key_name   = var.web_server_kp
  public_key = "${file("/root/.ssh/${var.web_server_kp}.pub")}"
}

## EC2 Security Group
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow SSH conection and HTTP requests from Control Server"
  vpc_id      = var.vpc

  ingress {
    description      = "SSH from anyone"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from anyone"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

## EC2 Instance 01
resource "aws_instance" "web_server_01" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.web_server_kp
  security_groups = [aws_security_group.web_server_sg.name]
  tags = {
    Name: "web-server-01"
  }
}

## EC2 Instance 02
resource "aws_instance" "web_server_02" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.web_server_kp
  security_groups = [aws_security_group.web_server_sg.name]
  tags = {
    Name: "web-server-02"
  }
}

## EC2 Elastic IP 01
resource "aws_eip" "web_server_01_eip" {
  instance = aws_instance.web_server_01.id
  vpc      = true
  tags = {
    Name: "web-server-01-eip"
  }
}


## EC2 Elastic IP 02
resource "aws_eip" "web_server_02_eip" {
  instance = aws_instance.web_server_02.id
  vpc      = true
  tags = {
    Name: "web-server-02-eip"
  }
}


# Control Server ------------------------------------------------
## EC2 Key Pair
resource "aws_key_pair" "control_server_kp" {
  key_name   = var.control_server_kp
  public_key = "${file("/root/.ssh/${var.control_server_kp}.pub")}"
}

## EC2 Security Group
resource "aws_security_group" "control_server_sg" {
  name        = "control_server_sg"
  description = "Allow SSH conection and HTTP requests from Control Server"
  vpc_id      = var.vpc

  ingress {
    description      = "SSH from anyone"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from anyone"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Jenkins from anyone"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "control-server-sg"
  }
}

## EC2 Instance
resource "aws_instance" "control_server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.control_server_kp
  security_groups = [aws_security_group.control_server_sg.name]
  tags = {
    Name: "control-server"
  }
}


## EC2 Elastic IP
resource "aws_eip" "control_server_eip" {
  instance = aws_instance.control_server.id
  vpc      = true
  tags = {
    Name: "control-server-eip"
  }
}

