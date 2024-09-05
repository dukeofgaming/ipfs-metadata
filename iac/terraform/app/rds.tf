# https://docs.aws.amazon.com/AmazonRDS/latest/PostgreSQLReleaseNotes/postgresql-versions.html#postgresql-version16
# Random ID to suffix the database name so that recreation does not make it fail
resource "random_id" "random_database_suffix" {
  byte_length = 4
}

locals {
  database_base_name = coalesce(
    var.database_name,
    replace(var.project, "-", "")
  )
  database_name = "${var.database_name}_${random_id.random_database_suffix.hex}"

  database_username = coalesce(
    var.database_username,
    replace(var.project, "-", "")
  )
}

resource "aws_db_instance" "database" {
  identifier     = "${var.project}-${local.environment}-db"
  instance_class = var.database_instance_class

  engine            = "postgres"
  engine_version    = "16.4"
  allocated_storage = 20
  db_name           = local.database_name
  username = local.database_username
  password = var.database_password

  #publicly_accessible    = false
  skip_final_snapshot = true

  # Networking
  vpc_security_group_ids = [
    aws_security_group.database.id
  ]
  db_subnet_group_name = aws_db_subnet_group.default.name

  # Monitoring
  backup_retention_period = 7
  #   monitoring_interval     = 60

  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade",
  ]
}

locals {
  private_subnets_rds = [
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]
}

resource "aws_subnet" "private_subnets_rds" {
  count = length(local.private_subnets_rds)

  vpc_id     = module.vpc.vpc_id
  cidr_block = local.private_subnets_rds[count.index]

  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = "${var.project}-${local.environment}-private-subnet"
  }
}

resource "aws_security_group" "database" {
  name        = "${var.project}-${local.environment}-rds-sg"
  description = "Allow ECS tasks access to Postgres"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = var.database_port
    to_port   = var.database_port
    protocol  = "tcp"
    cidr_blocks = [
      module.vpc.vpc_cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.project}-${local.environment}-subnet-group"
  subnet_ids = aws_subnet.private_subnets_rds[*].id
}