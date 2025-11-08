# create 3 security groups: frontend, backend, mysql

module "mysql_sg" {
    source          = "git::https://github.com/RahulGattu912/terraform-modules.git//terraform-aws-security-group?ref=main"
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "mysql"
    sg_description  = "Created for MySQL instances int expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

module "backend_sg" {
    source          = "git::https://github.com/RahulGattu912/terraform-modules.git//terraform-aws-security-group?ref=main"
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "backend"
    sg_description  = "Created for backend instances int expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

module "frontend_sg" {
    source          = "git::https://github.com/RahulGattu912/terraform-modules.git//terraform-aws-security-group?ref=main"
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "frontend"
    sg_description  = "Created for frontend instances int expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}

module "bastion_sg" {
    source          = "git::https://github.com/RahulGattu912/terraform-modules.git//terraform-aws-security-group?ref=main"
    environment     = var.environment
    project_name    = var.project_name
    sg_name         = "bastion"
    sg_description  = "Created for bastion instances int expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
    common_tags     = var.common_tags
}