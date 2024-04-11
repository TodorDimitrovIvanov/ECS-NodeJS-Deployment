
// The traffic router itself 
resource "aws_lb" "cluster-lb" {
  name = "${var.cluster_name}-lb"
  internal = false 
  security_groups = [aws_security_group.cluster-sec-grp.id] 
  subnets = [aws_subnet.cluster-subnet-1.id, aws_subnet.cluster-subnet-2.id] 

  load_balancer_type = "application"
}

// The incoming web traffic 
resource "aws_lb_target_group" "cluster-trgt-grp" {
  name = "${var.cluster_name}-trgt-grp"
  port = 80 
  protocol = "HTTP"
  vpc_id = aws_vpc.cluster-vpc.id
  target_type = "ip"
}

// Rules for incoming web traffic 
resource "aws_lb_listener" "cluster-lb-listener" {
  load_balancer_arn = aws_lb.cluster-lb.arn
  port    = 80 
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.cluster-trgt-grp.arn
    type             = "forward"
  }
}

output "load_balancer_dns_name" {
  value = aws_lb.cluster-lb.dns_name
  description = "The public(?) DNS of the Load Balancer"
}

