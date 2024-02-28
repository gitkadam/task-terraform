
 resource "aws_subnet" "private_subnet" {
   vpc_id            = aws_vpc.main.id
   cidr_block        = "10.0.2.0/24"
   availability_zone = "us-east-1a"
 }
 resource "aws_subnet" "private_subnet2" {
   vpc_id            = aws_vpc.main.id
   cidr_block        = "10.0.3.0/24"
   availability_zone = "us-east-1b"
 }
 resource "aws_security_group" "mysql_sg" {
   vpc_id = aws_vpc.main.id
   // Example: Allow inbound traffic on port 3306 from your application servers' security groups
 }

 resource "aws_db_subnet_group" "my_db_subnet_group" {
   subnet_ids = [
     aws_subnet.private_subnet.id, aws_subnet.private_subnet2.id
   ]
 }


resource "aws_kms_key" "my_kms_key" {
  description = "My KMS Key for RDS Encryption"
  deletion_window_in_days = 30

  tags = {
    Name = "MyKMSKey"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage           = 50
  engine               = "mysql"
  engine_version       = "5.7"
    db_subnet_group_name  = aws_db_subnet_group.my_db_subnet_group.name
   vpc_security_group_ids = [
     aws_security_group.mysql_sg.id
   ]
  auto_minor_version_upgrade  = false                         # Custom for Oracle does not support minor version upgrades
  backup_retention_period     = 7
  identifier                  = "ee-instance-demo"
  instance_class       = "db.t3.micro"
  kms_key_id                  = aws_kms_key.my_kms_key.arn
  multi_az                    = true 
  password                    = "dbpassward"
  username                    = "test"
  storage_encrypted           = true
  skip_final_snapshot = false
  final_snapshot_identifier = "my-db"

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

resource "aws_db_instance" "replica" {
  replicate_source_db = aws_db_instance.default.identifier
  instance_class = "db.t3.medium"
  backup_retention_period     = 7
  backup_window = "03:00-04:00"
  maintenance_window = "mon:04:00-mon:04:30"
  skip_final_snapshot = false
  final_snapshot_identifier = "my-db"
  performance_insights_enabled = true
  storage_encrypted = true
  kms_key_id = aws_kms_key.my_kms_key.arn

  # Enable Multi-AZ deployment for high availability
  multi_az = true
}
