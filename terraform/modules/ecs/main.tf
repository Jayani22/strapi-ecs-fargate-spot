resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster-jayani"
}

resource "aws_ecs_task_definition" "this" {
    family                   = "${var.project_name}-task-jayani"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = "1024"
    memory                   = "2048"
    execution_role_arn       = var.execution_role_arn

    container_definitions = jsonencode([
      {
        name  = "strapi"
        image = var.image_uri

        portMappings = [{
            containerPort = 1337
            hostPort      = 1337
        }]

        environment = [ 
            { name = "HOST", value = "0.0.0.0" },
            { name = "PORT", value = "1337" },
            { name = "NODE_ENV", value = "production" }
            { name = "DATABASE_CLIENT", value = "postgres" },
            { name = "DATABASE_HOST", value = var.db_endpoint },
            { name = "DATABASE_PORT", value = "5432" },
            { name = "DATABASE_NAME", value = "strapi" },
            { name = "DATABASE_USERNAME", value = var.db_username },
            { name = "DATABASE_PASSWORD", value = var.db_password },
            { name = "DATABASE_SSL", value = "true" },
            { name = "DATABASE_SSL_REJECT_UNAUTHORIZED", value = "false" },
        ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service-jayani"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = []
}