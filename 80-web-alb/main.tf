module "alb" {
  source                = "terraform-aws-modules/alb/aws"
  internal              = true # since this is private

  # expense-dev-app-alb
  name                  = "${var.project_name}-${var.environment}-app-alb"
  vpc_id                = data.aws_ssm_parameter.vpc_id.value
  subnets               = local.private_subnet_id

  create_security_group = false

  security_groups       = local.app_alb_sg_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-app-alb"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.arn # the ID and ARN of the load balancer we created
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1> Hello, I am from backend App ALB </h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.app-dev.${var.domain_name}"  # {any-text-or-string}.app-dev.learndevops.online : * means anything
  type    = "A" # alias

  # these are all ALB DNS name and zone information
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = false
  }
}