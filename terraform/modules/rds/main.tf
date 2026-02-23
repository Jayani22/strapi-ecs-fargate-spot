# DB Subnet Group
resource "aws_db_subnet_group" "this" {
    name       = "${var.project_name}-rds-subnet-group-jayani"
    subnet_ids = var.subnet_ids
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
    identifier              = "${var.project_name}-postgres-jayani"
    engine                  = "postgres"
    engine_version          = "15"
    instance_class          = "db.t3.micro"
    allocated_storage       = 20

    db_name                 = "strapi"
    username                = var.db_username
    password                = var.db_password #random_password.db_password.result
    
    db_subnet_group_name    = aws_db_subnet_group.this.name
    vpc_security_group_ids  = [var.rds_sg_id]

    skip_final_snapshot     = true
    publicly_accessible     = false
    deletion_protection     = false

    multi_az                = false
    storage_type            = "gp2"
}