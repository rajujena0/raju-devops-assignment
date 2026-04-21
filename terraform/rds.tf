# DB Subnet Group — RDS needs subnets in at least 2 AZs
resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = { Name = "${var.project}-db-subnet-group" }
}

# RDS PostgreSQL — db.t3.micro (free tier)
resource "aws_db_instance" "postgres" {
  identifier        = "${var.project}-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = var.db_instance_class
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  # Security
  publicly_accessible = false
  storage_encrypted   = true

  # Backup
  backup_retention_period = 0
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # Assignment settings — change in real prod
  skip_final_snapshot = true
  deletion_protection = false

  tags = { Name = "${var.project}-postgres" }
}
