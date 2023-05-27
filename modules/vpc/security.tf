

resource "aws_security_group" "public-sg" {
  name        = "NYP-${var.infra_env}-sg"
  description = "Public security group"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "NYP-${var.infra_env}-sg"
    }
  )
}

###
# Public Security Group
##

# resource "aws_security_group" "public" {
#   name = "cloudcasts-${var.infra_env}-public-sg"
#   description = "Public internet access"
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name        = "cloudcasts-${var.infra_env}-public-sg"
#     Role        = "public"
#     Project     = "cloudcasts.io"
#     Environment = var.infra_env
#     ManagedBy   = "terraform"
#   }
# }

# resource "aws_security_group_rule" "public_out" {
#   type        = "egress"
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]

#   security_group_id = aws_security_group.public.id
# }

# resource "aws_security_group_rule" "public_in_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.public.id
# }

# resource "aws_security_group_rule" "public_in_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.public.id
# }

# resource "aws_security_group_rule" "public_in_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.public.id
# }

# ###
# # Private Security Group
# ##

# resource "aws_security_group" "private" {
#   name = "cloudcasts-${var.infra_env}-private-sg"
#   description = "Private internet access"
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name        = "cloudcasts-${var.infra_env}-private-sg"
#     Role        = "private"
#     Project     = "cloudcasts.io"
#     Environment = var.infra_env
#     ManagedBy   = "terraform"
#   }
# }

# resource "aws_security_group_rule" "private_out" {
#   type        = "egress"
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]

#   security_group_id = aws_security_group.private.id
# }

# resource "aws_security_group_rule" "private_in" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "-1"
#   cidr_blocks = [module.vpc.vpc_cidr_block]

#   security_group_id = aws_security_group.private.id
# }