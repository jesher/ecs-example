resource "aws_alb_target_group" "alb_target_group_app" {
  name     = "${var.project}-${var.environment}-alb-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
  health_check {
    port                = 3000
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    path                = "/"
  }
}


resource "aws_alb_target_group" "alb_target_group_api" {
  name     = "${var.project}-${var.environment}-alb-target-group-api"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
  health_check {
    port                = 3000
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    path                = "/v1/healthcheck"
  }
}

/* security group for ALB */
resource "aws_security_group" "web_inbound_sg" {
  name        = "${var.project}-${var.environment}-web-inbound-sg"
  description = "Allow HTTP from Anywhere into ALB"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "alb_main" {
  name            = "${var.project}-${var.environment}-alb"
  subnets         = module.vpc.public_subnets
  security_groups = ["${aws_security_group.web_inbound_sg.id}"]
}

resource "aws_alb_listener" "main_listener" {
  load_balancer_arn = "${aws_alb.alb_main.arn}"
  port              = "80"
  protocol          = "HTTP"
  depends_on        = ["aws_alb_target_group.alb_target_group_app"]

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group_app.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_alb_listener.main_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group_api.arn
  }

  condition {
    path_pattern {
      values = ["/v1/*"]
    }
  }

  condition {
    host_header {
      values = [aws_alb.alb_main.dns_name] # you alter for your subdomain
    }
  }
}
