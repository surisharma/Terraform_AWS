variable "region" {
    description = "The AWS region to create resource in."
    default = "us-west-1"
    }
variable "public_subnet_1_cidr" {
    description = "CIDR Block for Public Subnet 1"
    default = "10.0.1.0/24"
} 
variable "public_subnet_2_cidr" {
    description = "CIDR Block for Public Subnet 2"
    default = "10.0.2.0/24"
} 
variable "private_subnet_1_cidr" {
    description = "CIDR Block for Private Subnet 1"
    default = "10.0.3.0/24"
} 
variable "private_subnet_2_cidr" {
    description = "CIDR Block for Private Subnet 2"
    default = "10.0.4.0/24"
} 
variable "availability_zones" {
    description = "Availability Zones"
    type = list(string)
    default = ["us-west-1b", "us-west-1c"]
}

# Load Balancer 
variable "health_check_path" {
    description = "Health check path for the default target group"
    default = "/ping/"
}

# ecs-django
variable "ecs_cluster_name" {
  description = "Name of the ecs cluster"
  default = production
}   