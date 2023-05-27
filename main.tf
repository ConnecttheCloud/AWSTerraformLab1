
module "vpc" {
  source = "./modules/vpc"

  infra_env       = var.infra_env
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

}

###########################################


resource "aws_lb" "app-lb" {
  name               = "NYP-Prod-AppLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vpc.security_group_public]
  subnets = [
    # module.vpc.vpc_public_subnets
    "${element(module.vpc.vpc_public_subnets, 0)}",
    "${element(module.vpc.vpc_public_subnets, 1)}",
    "${element(module.vpc.vpc_public_subnets, 2)}",
  ]
  tags = var.additional_tags
}

resource "aws_autoscaling_group" "ASG" {
  name             = "NYP-Prod-asg"
  min_size         = 3
  max_size         = 6
  desired_capacity = 3
  launch_template {
    id      = aws_launch_template.launch-template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [
    # "module.vpc.vpc_public_subnets"
    "${element(module.vpc.vpc_public_subnets, 0)}",
    "${element(module.vpc.vpc_public_subnets, 1)}",
    "${element(module.vpc.vpc_public_subnets, 2)}",
  ]
}


resource "aws_autoscaling_policy" "asg-policy" {
  name                   = "ASG-dynamic-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.ASG.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_launch_template" "launch-template" {
  name                   = "ASGtemplate-lt"
  image_id               = "ami-00b429b21feb2011e" # Replace with your desired AMI ID
  instance_type          = "t2.micro"              # Replace with your desired instance type
  vpc_security_group_ids = [module.vpc.security_group_public]
  user_data              = filebase64("./userdata.sh")
  tags                   = var.additional_tags
  key_name = "mykey"
}


resource "aws_lb_target_group" "lb-target" {
  name     = "LBtarget-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 3
    interval            = 30
    matcher             = 200
  }
  tags = var.additional_tags
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target.arn
  }
}


resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.ASG.id
  lb_target_group_arn    = aws_lb_target_group.lb-target.arn
}