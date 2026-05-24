resource "aws_security_group" "db_sg" {
  name        = "database-security-group"
  description = "Allow MySQL access"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "database-security-group"
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Project     = "IaC-Project"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "project-db-subnet-group"

  subnet_ids = [
  var.private_subnet_1_id,
  var.private_subnet_2_id
]

  tags = {
    Name        = "project-db-subnet-group"
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Project     = "IaC-Project"
  }
}


resource "aws_db_instance" "mysql_db" {
  identifier = "project-mysql-db"

  allocated_storage = 20

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name        = "project-mysql-db"
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Project     = "IaC-Project"
  }
}