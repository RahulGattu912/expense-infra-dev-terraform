module "vpc" {
    #source = "../terraform-aws-vpc"
    # When your module folder (for example, terraform-aws-vpc) lives inside a Git repo, you must:
    # Use the git:: protocol,
    # Reference the repo URL,
    # Specify the branch or tag via ?ref=, and
    # Add a // + folder path to target that specific subdirectory.

    source = "git::https://github.com/RahulGattu912/terraform-modules.git//terraform-aws-vpc?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_cidr = var.vpc_cidr
    common_tags = var.common_tags
    vpc_tags = var.vpc_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_required = true
}