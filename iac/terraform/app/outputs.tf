output "lb_url" {
  value = "http://${aws_lb.alb.dns_name}"
}

output "database" {
  value = {
    rds_endpoint  = aws_db_instance.database.endpoint
    database_name = aws_db_instance.database.db_name
    username      = aws_db_instance.database.username
  }
}