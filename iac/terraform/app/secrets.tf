resource "aws_secretsmanager_secret" "rds_master_password" {
  name = "${var.project}-${var.environment}-rds-master-password"
}

resource "aws_secretsmanager_secret_version" "rds_master_password" {
  secret_id     = aws_secretsmanager_secret.rds_master_password.id
  secret_string = var.database_password
}