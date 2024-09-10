
# The creation of this file will inform developers of what applied and where
# but the file will not be automatically consumed by the pipeline 
# if put in version control.
resource "local_file" "foo" {
  content  = jsonencode({
    # Passed by the user or pipeline on a first run
    environment         = var.environment           
    container_image     = "${var.container_image}"

    # Dumped to encourage devs to only modify 
    # their local terraform.tfvars.json ()
    container_port      = var.container_port        
  })

  filename = "${path.module}/terraform-${var.environment}.tfvars.json"
}