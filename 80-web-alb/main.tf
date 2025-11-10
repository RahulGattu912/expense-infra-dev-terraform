module "alb" {
  source                = "terraform-aws-modules/alb/aws"
  internal              = false # this is public

  # expense-dev-web-alb
  name                  = "${var.project_name}-${var.environment}-web-alb"
  vpc_id                = data.aws_ssm_parameter.vpc_id.value
  subnets               = local.public_subnet_id

  create_security_group = false

  security_groups       = local.web_alb_sg_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-web-alb"
    }
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.alb.arn # the ID and ARN of the load balancer we created
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.web_alb_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1> Hello, I am from frontend web ALB with HTTPS </h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "web_alb" {
  zone_id = var.zone_id
  name    = "*.${var.domain_name}"  # {any-text-or-string}.app-dev.learndevops.online : * means anything
  type    = "A" # alias

  # these are all ALB DNS name and zone information
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = false
  }
}