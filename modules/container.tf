resource "aws_ecs_cluster" "nodejs-cluster" {
  name = "nodejs-cluster"
}

# Define the service
resource "aws_ecs_service" "nodejs-cluster-service" {
  name            = "nodejs-cluster-service"
  cluster         = aws_ecs_cluster.nodejs-cluster.id
  task_definition = aws_ecs_task_definition.nodejs-cluster-container.arn
  desired_count   = 1
  launch_type     = "EC2"

  network_configuration {
    subnets         = ["subnet-xxxxxx"]
    security_groups = ["sg-xxxxxx"]
  }

  depends_on = [aws_ecs_task_definition.nodejs-cluster-container]
}

resource "aws_ecs_task_definition" "nodejs-cluster-container" {
  family                   = "nodejs-cluster"
  container_definitions   = <<TASK_DEFINITION
  [
    {
      "name": "nodejs-container",
      "image": "your_docker_image",
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
