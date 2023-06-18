module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["web_server", "database_server"])

  name = "instance-${each.key}"

  instance_type          = "t2.micro"
  key_name               = "ec2-key"
  monitoring             = true
  vpc_security_group_ids = [
    aws_security_group.web_server_sg.id,
    aws_security_group.database_server_sg.id,
  ]
  subnet_id              = data.aws_subnet.my_subnet.id

  tags = {
    Name      = each.key
    Stage     = var.stage_name
    ManagedBy = "Terraform"
  }
}

data "aws_subnet" "my_subnet" {
  id = var.my_subnets
}

output "subnet_cidr_block" {
  value = data.aws_subnet.my_subnet.cidr_block
}

resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Security group for SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database_server_sg" {
  name        = "database-server-sg"
  description = "Security group for MySQL"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





