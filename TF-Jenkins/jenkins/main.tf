variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "subnet_id" {}
variable "user_data_install_jenkins" {}
variable "sg_for_jenkins" {}
variable "enable_public_ip_address" {}
variable "public_key" {}
output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /Users/rahulwagh/.ssh/aws_ec2_terraform ubuntu@", aws_instance.jenkins_ec2_instance_ip.public_ip)
}
output "dev_proj_1_ec2_instance_public_ip" {
    value  = ws_instance.jenkins_ec2_instance_ip.public_ip
}
output "jenkins_ec2_instance_ip" {
    value = aws_instance.jenkins_ec2_instance_ip.id
}
resource "aws_instance" "jenkins_ec2_instance_ip" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  user_data                   = var.user_data_install_jenkins
  vpc_security_group_ids      = var.sg_for_jenkins
  associate_public_ip_address = var.enable_public_ip_address
  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}
resource "aws_key_pair" "jenkins_ec2_instance_public_key" {
    key_name     = "aws_ec2_terraform"
    public_key   = var.public_key
}