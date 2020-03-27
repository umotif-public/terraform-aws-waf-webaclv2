provider "aws" {
  region = "eu-west-1"
}


#####
# VPC and subnets
#####
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.21"

  name = "simple-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
}

#####
# ALB
#####
module "alb" {
  source  = "umotif-public/alb/aws"
  version = "~> 1.0"

  name_prefix        = "alb-example"
  load_balancer_type = "application"
  internal           = false
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "alb_80" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = module.fargate.target_group_arn
  }
}

#####
# Security Group Config
#####
resource "aws_security_group_rule" "alb_ingress_80" {
  security_group_id = module.alb.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "task_ingress_80" {
  security_group_id        = module.fargate.service_sg_id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = module.alb.security_group_id
}

#####
# ECS cluster and fargate
#####
resource "aws_ecs_cluster" "cluster" {
  name = "example-ecs-cluster"
}

module "fargate" {
  source  = "umotif-public/ecs-fargate/aws"
  version = "~> 1.1.1"

  name_prefix        = "ecs-fargate-example"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.public_subnets
  lb_arn             = module.alb.arn
  cluster_id         = aws_ecs_cluster.cluster.id

  task_container_image   = "marcincuber/2048-game:latest"
  task_definition_cpu    = 256
  task_definition_memory = 512

  task_container_port             = 80
  task_container_assign_public_ip = true

  health_check = {
    port = "traffic-port"
    path = "/"
  }
}

module "waf" {
  source = "../.."

  name_prefix = "test-waf-setup"
  alb_arn     = module.alb.arn

  enable_DefaultActionAllow = true

  enable_CommonRuleSet         = true
  enable_PHPRuleSet            = true
  enable_LinuxRuleSet          = true
  enable_SQLiRuleSet           = true
  enable_KnownBadInputsRuleSet = true
  enable_UnixRuleSet           = true

  enable_OverrideActionCountCommonRuleSet         = false
  enable_OverrideActionCountPHPRuleSet            = false
  enable_OverrideActionCountLinuxRuleSet          = false
  enable_OverrideActionCountSQLiRuleSet           = false
  enable_OverrideActionCountKnownBadInputsRuleSet = false
  enable_OverrideActionCountUnixRuleSet           = false
}
