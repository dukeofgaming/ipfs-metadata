This module will help you create the state backend and service accounts you need for an environment (e.g., users and pipeline).

# Setup
## Initial Setup



1. Copy the `.env.sh.dist` file to `.env.sh` and fill in the required values, then run:

    ```sh
        source .env.sh
    ```

2. Copy the `terraform.tfvars.json.dist` file to `terraform.tfvars.json` and fill in your current repository as a value.

    ```json
        {"github_repository":"dukeofgaming/ipfs-metadata"}
    ```

    > **NOTE**: If you don't do this, sure to change  the `terraform.tfvars` value for your repository first, and make a commit.

3. Run `terraform init` and `terraform apply`. 
    
    > **NOTE**: If this is your first run, ensure the `setup_core_environment` and `update_core_backend_hcl` variables are configured appropriately in your `terraform.tfvars` or passed as `-var` arguments to `terraform apply`. 
    >
    > By default they are both set to true, which will create the core environment and generate the `backend.hcl` file respectively.
    >
    > ```hcl
    >   github_repository = "dukeofgaming/ipfs-metadata"
    > ```
    >

3. Choose your desired backend:

    - **S3 (RECOMMENDED DEFAULT)**: 

        1. After the first `terraform apply`, ensure the `backend.hcl` file has been generated with the correct backend configuration. 
        
        2. Copy `backend.tf.dist` to `backend.tf` 

            > NOTE: `backend.tf` is ignored so that you can have a local backend for the core project. Suitable for experimentation.
        
        3. `terraform init -backend-config=backend.hcl` to reinitialize Terraform with the new backend settings.

        - The `setup_core_environment` variable controls whether the core environment's resources, including the state backend (S3 bucket and DynamoDB table), are created. By default these are set to `true` to enable the creation of these resources.

        - The `update_core_backend_hcl` variable, when set to `true` along with `setup_core_environment`, triggers the generation of the `backend.hcl` for the **core environment** file after applying your Terraform configuration. 

    - **Local**: Do nothing. The state will continue to be stored locally. 
        
        > Note: This is okay for experimentation, not for production. Sensitive information can be stored unencrypted in the state, which if put in version control **it will** be a serious security risk.

Once you see everything is working, you can move on to the [`app` environments](../app/README.md).

## Existing setup

If you have an existing setup in version control, you can use the `terraform init -backend-config=backend.hcl` command to initialize the backend configuration.

If you wish to put the backend configuration in version control, save your backend config with a file name *different* than `backend.hcl`.

## `backend.hcl` generation

By default, on the first run and onwards, the `backend.hcl` file will be generated for you.

To omit the creation of the core environment, set `setup_core_environment` to `false` in the `terraform.tfvars.json` file:

```hcl
setup_core_environment = false
```

To prevent automatic generation of the `backend.hcl` file, set `update_backend_hcl` to `false`:

```hcl
update_core_backend_hcl = false
```