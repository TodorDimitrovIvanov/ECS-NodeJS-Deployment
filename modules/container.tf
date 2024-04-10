variable "cluster_name" {}

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

  depends_on = [aws_ecs_task_definition.cluster-container]
}

resource "aws_ecs_task_definition" "cluster-container" {
  family                  = "${var.cluster_name}"
  network_mode            = "awsvpc"
  container_definitions   = <<TASK_DEFINITION
  [
    {
      "name": "cluster-container",
      "image": "node:hydrogen-buster-slim",
      "cpu": 256,
      "memory": 512,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ]
    }
  ]
  TASK_DEFINITION
}

