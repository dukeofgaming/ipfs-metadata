locals {
    terraform_state_bucket_name = "terraform-state-backend"
}

terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.65.0"
        }
    }

    backend "s3" {}
}