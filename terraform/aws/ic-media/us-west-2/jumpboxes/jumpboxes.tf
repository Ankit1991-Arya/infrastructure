# resource "aws_instance" "MS_Demo_EC2" {
#   ami                         = "ami-02b43d6c625775ddb"
#   instance_type               = "t2.micro"
#   associate_public_ip_address = false
#   # iam_instance_profile        = "ServiceAccess-media-services-media-server"
#   key_name = "terraform-key"
#   tags = {
#     "Type" = "Created By Terraform"
#     "Name" = "MS-EC2-1-Windows-2019"
#   }

#   metadata_options {
#     http_endpoint = "enabled"
#     http_tokens   = "required"
#   }

#   root_block_device {
#     encrypted = true
#   }

#   ebs_block_device {
#     device_name           = "/dev/sdg"
#     volume_size           = 5
#     volume_type           = "gp2"
#     delete_on_termination = false
#     encrypted             = true
#   }
# }

# Distroy

