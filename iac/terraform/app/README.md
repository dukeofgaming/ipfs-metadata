
## Authentication

1. Copy the `.env.dist` file to `.env` and fill in the required values.
2. Export the variables into your current shell with `source .env`.

## Initial setup

If running this project for the first time, this same codebase will help you create the S3 bucket and DynamoDB table required for terraform state backend. So be sure to rnu `core` first: [core README](../core/README.md)

Follow these steps:

1. Copy the `.env.sh.dist` file to `.env.sh` and fill in the required values, then run:
    ```sh
    source .env.sh
    ```
2. After running `core` you should be able to see 3 `backend` files in the form of `backend-<environment>.hcl`. 

3. Copy the `terraform.tfvars.json.dist` file to `terraform.tfvars.json`


4. **[RECOMMENDED]** Copy `backend.tf.dist` to `backend.tf` to be able to use the S3 backends.


4. Run the `switch-backend.sh` script to switch to the desired backend:
    ```sh
    chmod +x ./switch-backend.sh
    ./switch-backend.sh dev
    ```

4. Once you do, you should see a terraform init message succeed. Go ahead and plan/apply:

    ```sh
    terraform plan
    terraform apply
    ```

    > NOTE: you may need to change to something like `nginx:latest` (port 80) or `pgadmin4:latest` (port 8080) to have a successful first deployment ECS, as you don't have an image yet.
