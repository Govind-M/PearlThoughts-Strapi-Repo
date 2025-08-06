resource "aws_db_subnet_group" "strapi_db_subnet_group_gov" {
  name       = "strapi-db-subnet-group-gov"
  subnet_ids = local.public_subnet_ids

  tags = {
    Name = "Strapi DB subnet group"
  }
}

resource "aws_db_parameter_group" "strapi_postgres_param_group" {
  name        = "strapi-postgres-param-group-gov"
  family      = "postgres17"
  description = "Custom parameter group for Strapi Postgres"
 
  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
 
  tags = {
    Name = "strapi_postgres_param_group-gov"
  }
}

resource "aws_db_instance" "strapi_postgres" {
  identifier         = "strapi-gov"
  engine             = "postgres"
  engine_version     = "17.4"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_name            = "strapi"
  username           = "strapi"
  password           = "strapi123"
  skip_final_snapshot = true
  publicly_accessible = true
  db_subnet_group_name = aws_db_subnet_group.strapi_db_subnet_group_gov.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.strapi_postgres_param_group.name

    tags = {
    Name = "strapi-gov-db"
  }
}

