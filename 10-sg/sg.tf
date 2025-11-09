# create 3 security groups: frontend, backend, mysql

module "mysql_sg" {
    source          = var.sg_source
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "mysql"
    sg_description  = "Created for MySQL instances in expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

module "backend_sg" {
    source          = var.sg_source
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "backend"
    sg_description  = "Created for backend instances in expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

module "frontend_sg" {
    source          = var.sg_source
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "frontend"
    sg_description  = "Created for frontend instances in expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

module "bastion_sg" {
    source          = var.sg_source
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "bastion"
    sg_description  = "Created for bastion instances in expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

module "app_alb_sg" {
    source          = var.sg_source
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "app-alb"
    sg_description  = "Created for backend ALB instances in expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

# vpn security group. ports -> 22,443,1194,943
# 22 - to login to server
# 443 - to login to browser
# 1194, 943 - internal ports/administrative ports
module "vpn_sg" {
    source          = var.sg_source
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "vpn"
    sg_description  = "Created for vpn instances in expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

# app alb accepting traffic from bastion
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = [module.bastion_sg.sg_id]
  security_group_id =  module.app_alb_sg.sg_id
}

# if you don't write this. you can't connect to bastion ec2 instance
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ] # we need to make bastion host accessible from public internet or we can give a static ip, so that we can access bastion host from that ip only
  security_group_id =  module.backend_sg_id.sg_id
}

resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # usually it should be static IP
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id =  module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  # usually it should be static IP
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id =  module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  # usually it should be static IP
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id =  module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  # usually it should be static IP
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id =  module.vpn_sg.sg_id
}

# alb accepting traffic from vpn
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # usually it should be static IP
  source_security_group_id = module.vpn_sg.sg_id # app alb should accept traffic from vpn
  security_group_id =  module.vpn_sg.sg_id
}