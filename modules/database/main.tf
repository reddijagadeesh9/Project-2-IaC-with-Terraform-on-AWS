# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "main-db-subnet-group"

  subnet_ids = [
    var.private_subnet_1_id,
    var.private_subnet_2_id
  ]

  tags = {
    Name = "DB Subnet Group"
  }
}

# RDS Instance
resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  storage_encrypted          = true
  multi_az                   = true
  deletion_protection        = true
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  tags = {
    Name = "mysql-rds"
  }
}

