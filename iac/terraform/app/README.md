
## Authentication

1. Copy the `.env.dist` file to `.env` and fill in the required values.
2. Export the variables into your current shell with `source .env`.

## Initial setup

If running this project for the first time, this same codebase will help you create the S3 bucket and DynamoDB table required for terraform state backend.

Follow these steps:

1. Comment the `backend` block in main.tf and initialize the backend locally:
    ```sh
    terraform init
    ```

2. Create only the resources needed for the S3 backend:
    ```sh
    terraform apply -target=module.s3_backend
    ```

3. Uncomment the `backend` block and migrate to the newly created S3 backend:
    ```sh
    terraform init -migrate-state
    ```


