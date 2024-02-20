resource "aws_autoscaling_group" "ecs-cluster" {
  name                      = "${var.ecs_cluster_name}_auto_scaling_group"
  max_size                  = "${var.autoscale.min}"
  min_size                  = "${var.autoscale.max}"
  #health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = "${var.autoscale_desired}"
  #force_delete              = true
  #placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.ecs.name
  vpc_zone_identifier       = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

#  instance_maintenance_policy {
 #   min_healthy_percentage = 90
 #   max_healthy_percentage = 120
  }
