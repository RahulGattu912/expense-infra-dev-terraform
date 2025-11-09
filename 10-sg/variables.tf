variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = true
    }
}

variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "sg_source" {
    default = "git::https://github.com/RahulGattu912/terraform-modules.git//terraform-aws-security-group?ref=main"
}
