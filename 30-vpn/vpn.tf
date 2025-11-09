resource "aws_key_pair" "openvpnas" {
    key_name = "openvpnas"
    public_key = file("E:\\siva-kumar-devops\\openvpnas.pub") # path to public key. path type varies from mac, windows
}

# we need to create this in public subnet of expense vpc. if not mentioned it is created in default vpc
resource "aws_instance" "vpn" {
    ami                     = data.aws_ami.openvpn.id
    vpc_security_group_ids  = [ data.aws_ssm_parameter.vpn_sg_id.value ]
    # here we can provide keys which exist in aws itself
    # key_name = aws_key_pair.openvpnas.key_name                              
    instance_type           = "t2.micro"

    # aws accepts this format: subnet-cbyisbdo9bs9,subnet-buweb8bq0wh9 but not [" subnet-cbyisbdo9bs9","subnet-buweb8bq0wh9"]. 
    # terraform accepts this format [" subnet-cbyisbdo9bs9","subnet-buweb8bq0wh9"] but not subnet-cbyisbdo9bs9,subnet-buweb8bq0wh9 
    # so we need to split it using "," and get the first item in the list. It is stored in locals.tf
    subnet_id               = local.public_subnet_id 
    
    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-vpn"
        }
    )
}