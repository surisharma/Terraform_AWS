variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "ec2_jenkins_sg_name" {}

resource "aws_security_group" "ec2_sg_ssh_http" {
    name            =  var.ec2_sg_name
    description     = "Enable the Port 22(SSH) & Port 80(HTTP)"
    vpc_id          = var.vpc_id
    # ssh for terraform remote exec
    ingress {
        description = "Allow remote SSH from anywhere"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
    }
    # Enable HTTP 
    ingress {
        description   = "Allow HTTP request from anywhere"
        cidr_blocks   = ["0.0.0.0/0"]
        from_port     = 80
        to_port       = 80
        protocol      = "tcp"
    } 
    # Enable HTTPS
    ingress {
        description   = "Allow HTTP request from anywhere"
        cidr_blocks   = ["0.0.0.0/0"]
        from_port     = 443
        to_port       = 443
        protocol      = "tcp"
    } 
    # Outgoing request
    egress {
        description   = "Allow Outgoing request"
        cidr_blocks   = ["0.0.0.0/0"]
        from_port     = 0
        to_port       = 0
        protocol      = "-1"
    } 
    tags = {
        Name = "Security Groups to allow SSH(22), HTTP(80) and HTTPS(443)"
    }
}

resource "aws_security_group" "ec2_jenkins_port_8080" {
    name            =  var.ec2_jenkins_sg_name
    description     = "Enable the Port 8080 for Jenkins"
    vpc_id          = var.vpc_id
    # Enable Jenkins Port 
    ingress {
        description   = "Allow 8080 port to access jenkins"
        cidr_blocks   = ["0.0.0.0/0"]
        from_port     = 8080
        to_port       = 8080
        protocol      = "tcp"
    } 
    
        tags = {
        Name = "Security Groups to allow 8080 port to access jenkins"
    }
}
