# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = "${var.project_name}-alb-sg-jayani"
  description = "Allow HTTP from internet"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name   = "${var.project_name}-ecs-sg-jayani"
  description = "Allow traffic from ALB"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow 1337 port from ALB"
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
    name   = "${var.project_name}-rds-sg"
    description = "Allow PostgreSQL from ECS"
    vpc_id = var.vpc_id

    ingress {
      description       = "Allow 5432 port from ECS"
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        security_groups = [aws_security_group.ecs_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}