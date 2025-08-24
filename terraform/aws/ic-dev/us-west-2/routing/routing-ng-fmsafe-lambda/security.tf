#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "fmsafe-lambda-sg" {
  name        = "fmsafe-lambda-sg"
  description = "This is the Lambda function created for Routing-ng-fmsafe"
  vpc_id      = data.aws_db_subnet_group.routing-ng-subnet.vpc_id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"          # Allows all protocols
    cidr_blocks      = ["0.0.0.0/0"] # Allows all IP addresses
    ipv6_cidr_blocks = ["::/0"]
  }
}

//This will Let Lambda talk to RDS instance
resource "aws_vpc_security_group_ingress_rule" "allow_fmsafe_lambda" {
  security_group_id            = data.aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.fmsafe-lambda-sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

