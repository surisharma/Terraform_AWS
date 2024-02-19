resource "aws_lb" "produciton" {
  name               = "${var.ecs_cluster_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public_subnet_2.id]
}

# Target group
resource "aws_alb_target_group" "default-target-group" {
  name     = "${var.ecs_cluster_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.produciton-vpc_id

  health_check {
    path = var.health_check_path
    port = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

# Listner (redirect traffic from the load balancer to the target group)
resource "aws_alb_listener" "ecs-alb-http-listener" {
    load_balancer_arn = aws_lb.produciton.id
    port              = "80"
    protocol          = "HTTP"
    depends_on        = [aws_alb_target_group.default-target-group]

    default_action {
        type             = "forward"
    target_group_arn = aws_lb_target_group.default-target-group.arn
     }
}