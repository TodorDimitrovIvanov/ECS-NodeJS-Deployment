// The traffic router itself 
resource "aws_lb" "nodejs-lb" {
  name = "nodejs-lb"
  internal = false # Set to true if for internal traffic only
  security_groups = [aws_security_group.app_sg.id] # Replace with your security group

  subnets = aws_subnet.public_subnets.*.id

  load_balancer_type = "application"
}

// The incoming web traffic 
resource "aws_lb_target_group" "nodejs-trgt-grp" {
  name = "nodejs-trgt-grp"
  port = 80 # Port for communication with targets (modify if needed)
  protocol = "http"
  vpc_id = aws_vpc.main_vpc.id
}

// The containers that the traffic will be routed to 
resource "aws_lb_target_group_attachment" "nodejs-trgt-grp-attch" {
  target_group_arn = aws_lb_target_group.nodejs-trgt-grp.arn
  target_id        = aws_ecs_service.nodejs-cluster-service.arn
}

// Rules for incoming web traffic 
resource "aws_lb_listener" "nodejs-lb-listener" {
  load_balancer_arn = aws_lb.nodejs-lb.arn
  port    = 80 # Port for incoming traffic
  protocol = "http"

  default_action {
    target_group_arn = aws_lb_target_group.nodejs-trgt-grp.arn
    type             = "forward"
  }
}

