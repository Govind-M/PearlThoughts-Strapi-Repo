resource "aws_ecs_cluster" "strapi_cluster" {
    name = "strapi-cluster-gov"
    setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "strapi_logs" {
  name              = "/ecs/strapi-gov"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "strapi_task_definition" {
  family                   = "strapi-task-definition-gov"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([{
    name      = "strapi-gov"
    image     = "607700977843.dkr.ecr.us-east-2.amazonaws.com/strapi-repo-gov:latest"
    essential = true
    portMappings = [{
      containerPort = 1337
      hostPort      = 1337
    }]

    environment = [
        { name = "DATABASE_CLIENT",      value = "postgres" },
        { name = "DATABASE_HOST",        value = "strapi-gov.cbymg2mgkcu2.us-east-2.rds.amazonaws.com" },
        { name = "DATABASE_PORT",        value = "5432" },
        { name = "DATABASE_NAME",        value = "strapi" },
        { name = "DATABASE_USERNAME",    value = "strapi" },
        { name = "DATABASE_PASSWORD",    value = "strapi123" },
        { name = "DATABASE_SSL",         value = "false" },
        { name = "DB_POOL_MIN",       value = "0" },
        { name = "DB_POOL_MAX",       value = "10" },

        #strapi secrets
        { name = "APP_KEYS", value = "L5I6vf+NNnQIh0UGrTIFnA==,BTZAvKySoeTdpCMtyeZnJg==,JTbllD4Pnier6r3uXQqnmA==,QXL2Hl61igdl9XKFlpcyhw==" },
        { name = "API_TOKEN_SALT", value = "WqtqbTyJqy0iTW65LWmfdQ==" },
        { name = "ADMIN_JWT_SECRET", value = "/JQoGBGNLYFq+YPFSIRniw==" },
        { name = "TRANSFER_TOKEN_SALT", value = "O7vRJbcWMsapKQRYrN9c0Q==" },
        { name = "ENCRYPTION_KEY", value = "atqhTgUcnczo/doA51cPAw==" },
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = aws_cloudwatch_log_group.strapi_logs.name
        awslogs-region        = "us-east-2"
        awslogs-stream-prefix = "ecs"
        }
      }
  }])
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service-gov"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task_definition.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  enable_execute_command = true

  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_tasks_sg.id]
    # security_groups = [aws_security_group.strapi_sg.id]
    subnets            = local.public_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_blue.arn
    container_name   = "strapi-gov"
    container_port   = 1337
  }

  depends_on = [aws_db_instance.strapi_postgres, aws_lb_listener.http]
  # depends_on = [aws_lb_listener.http]

  force_new_deployment = true


  deployment_controller {
    type = "CODE_DEPLOY"
  }
}

