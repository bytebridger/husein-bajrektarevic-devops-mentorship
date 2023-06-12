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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0ce2f996605c388e7"
  instance_type = var.instance_type
  subnet_id     = "subnet-0f2293bbca5229391"  
  key_name      = "ec2-key"
  tags = {
    Name  = var.instance_name
    Stage = var.stage_name
  }

  vpc_security_group_ids = [
    aws_security_group.web_server_sg.id,
    aws_security_group.database_server_sg.id,
  ]
}

resource "aws_instance" "database_server" {
  ami           = "ami-0ce2f996605c388e7"
  instance_type = var.instance_type
  subnet_id     = "subnet-02e9014677366eaf1"  # Replace with the ID of your subnet in eu-central-1b
  key_name      = "ec2-key"
  tags = {
    Name  = "database-server"
    Stage = var.stage_name
  }

  vpc_security_group_ids = [
    aws_security_group.web_server_sg.id,
    aws_security_group.database_server_sg.id,
  ]
}
