data "aws_ami" "openvpn" {
    most_recent = true
    owners      = [ "679593333241" ] # openvpn server community edition

    filter {
        name    = "name"
        values  = ["OpenVPN Access Server Community Image-fe8020db-*"]
    }

    filter {
        name    = "virtualization-type"
        values  = ["hvm"]
    }

    filter {
        name    = "root-device-type"
        values  = ["ebs"]
    }

}

data "aws_ssm_parameter" "vpn_sg_id" {
    name = "/${var.project_name}/${var.environment}/vpn_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}