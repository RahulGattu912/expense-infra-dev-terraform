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

variable "zone_id" {
    default = "Zo21448939NMXP965QUTYE" # check in r53
}

variable "domain_name" {
    default = "learndevops.online"
}