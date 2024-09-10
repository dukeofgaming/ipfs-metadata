resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.name}-${var.lock_table_name}-${random_id.random_suffix.hex}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform Locks Table"
  }
}