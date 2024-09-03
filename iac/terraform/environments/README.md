This module will help you create the state backend and service accounts you need for an environment (e.g. users and pipeline)

# Setup
## Initial Setup

1. Copy the `.env.sh.dist` file to `.env.sh` and fill in the required values, then use `source .env.sh` to set the environment variables in your shell session.
3. Run `terraform init` and `terraform apply`. If this is your first run you will need to comment the `backend "s3" {}` block in `iac/terraform/environments/main.tf`
3. **RECOMMENDED**: Setup the backend for this project using the default `core` environment.
    1. Run the `terraform output` command to see the values of `core_state`.
    2. Copy the file `backend.tf.dist` to `backend.tf` and fill in the values.
    3. Run `terraform init -backend-config=backend.hcl`.


## Existing setup

If you have an existing setup in version control, you can use the `terraform init -backend-config=backend-somesetup.hcl` command to initialize the backend configuration.

If you wish to put the backend configuration in version control, save your backend config with a file name *different* than `backend.hcl`.

If you wish to ommit the creation of the core environment, set this to false in the `terraform.tfvars` file:

```hcl
setup_core_environment = false
```