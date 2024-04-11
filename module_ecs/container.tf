
resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster_name}-cluster"
}

# Define the service
resource "aws_ecs_service" "cluster-service" {
  name            = "${var.cluster_name}-ecs-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.cluster-container.arn
  desired_count   = 1
  launch_type     = "EC2"

  network_configuration {
    subnets         = [aws_subnet.cluster-subnet-1.id, aws_subnet.cluster-subnet-2.id]
    security_groups = [aws_security_group.cluster-sec-grp.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cluster-trgt-grp.arn
    container_name   = "${var.cluster_name}-container"
    container_port   = 3000
  }

  depends_on = [aws_ecs_task_definition.cluster-container]
}

resource "aws_ecs_task_definition" "cluster-container" {
  family                  = "${var.cluster_name}"
  network_mode            = "awsvpc"
  container_definitions   = <<TASK_DEFINITION
  [
    {
      "name": "${var.cluster_name}-container",
      "image": "iligard/nodejs-app:latest",
      "cpu": 256,
      "memory": 512,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "tcp"
        }
      ]
    }
  ]
  TASK_DEFINITION
}

