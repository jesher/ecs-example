module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project}-${var.environment}-ecs-cluster"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}



/* Security Group for ECS */
resource "aws_security_group" "ecs_service" {
  vpc_id      = "${module.vpc.vpc_id}"
  name        = "${var.environment}-ecs-service-sg"
  description = "Allow egress from container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

################################
#### LOGS
################################

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.project}-${var.environment}-log-grp-app"
  tags = {
    Environment = var.environment
  }
}

################################
#### ECR
################################

resource "aws_ecr_repository" "repository_app" {
  name = "${var.project}-${var.environment}/app"
}

resource "aws_ecr_repository" "repository_api" {
  name = "${var.project}-${var.environment}/api"
}

################################
#### ECS
################################

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.environment}-ecs-cluster"
}


resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs-role.arn
  task_role_arn            = aws_iam_role.ecs-role.arn
  container_definitions    = <<DEFINITION
[
  {
    "cpu": 256,
    "memory": 256,
    "image": "${aws_ecr_repository.repository_app.repository_url}:latest",
    "name": "app",
    "networkMode": "awsvpc",
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 1000000,
        "hardLimit": 1000000
      }
    ],
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "logConfiguration": {
	    "logDriver": "awslogs",
	    "options": {
	        "awslogs-group": "${aws_cloudwatch_log_group.main.name}",
	        "awslogs-region": "${var.AWS_REGION}",
	        "awslogs-stream-prefix": "${var.project}-${var.environment}"
	    }
	}
  }
]
DEFINITION

}


resource "aws_ecs_task_definition" "api" {
  family                   = "api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs-role.arn
  task_role_arn            = aws_iam_role.ecs-role.arn
  container_definitions    = <<DEFINITION
[
  {
    "cpu": 256,
    "memory": 256,
    "image": "${aws_ecr_repository.repository_api.repository_url}:latest",
    "name": "api",
    "networkMode": "awsvpc",
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 1000000,
        "hardLimit": 1000000
      }
    ],
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "logConfiguration": {
	    "logDriver": "awslogs",
	    "options": {
	        "awslogs-group": "${aws_cloudwatch_log_group.main.name}",
	        "awslogs-region": "${var.AWS_REGION}",
	        "awslogs-stream-prefix": "${var.project}-${var.environment}"
	    }
	}
  }
]
DEFINITION

}

# service app
resource "aws_ecs_service" "app" {
  name                               = "${var.project}-${var.environment}-ecs-service-app"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.app.arn
  desired_count                      = 3
  launch_type                        = "FARGATE"
  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_service.id]
    subnets         = module.vpc.public_subnets
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group.id
    container_name   = "app"
    container_port   = 3000
  }
  depends_on = [aws_alb_listener.openjobs]
}

# service api
resource "aws_ecs_service" "api" {
  name                               = "${var.project}-${var.environment}-ecs-service-api"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.api.arn
  desired_count                      = 3
  launch_type                        = "FARGATE"
  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_service.id]
    subnets         = module.vpc.public_subnets
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group_api.id
    container_name   = "api"
    container_port   = 3000
  }
  depends_on = [aws_alb_listener.openjobs]
}
