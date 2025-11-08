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

variable "zone_id" { # hosted zone id
    default = "Z021448929NXMW4P65QE"
}

variable "domain_name" {
    default = "learndevops.online"
}