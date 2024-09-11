# NFT Metadata Scraper

This application scrapes NFT metadata from IPFS using a CSV list of IPFS CIDs and stores the results in a PostgreSQL database. It also hosts an API that allows users to retrieve all stored metadata or a specific row based on a CID.

## Features

- Read a list of IPFS CIDs from a CSV file
- Fetch metadata for each CID from IPFS
- Store the `name` and `image` fields in a PostgreSQL database
- Provide an API to retrieve all data or a specific row based on a CID

## Prerequisites

- Go 1.19 or higher
- PostgreSQL
- Docker for running the app (optional) and PostgreSQL in a container, if desired
- [jq](https://jqlang.github.io/jq/download/) for handling some JSON configuration (optional, used for GitHub Actions)
## 🚀 New Features

- 🐳 **Containerization for Local Development**: Utilizes Docker Compose for easy setup and teardown of the development environment. See [ADR 1](docs/adrs/1%20-%20Docker%20Compose%20for%20local%20development.md).

- 🚑 **Health Check Endpoint**: A new `/healthcheck` endpoint checks database connectivity and returns the application's version, improving load balancer integration. See [ADR 10](docs/adrs/10%20-%20Healtcheck%20endpoint.md).

- 🏗️ **Terraform Infrastructure**: Infrastructure as Code using Terraform for reproducible and scalable cloud environments. See [ADR 2](docs/adrs/2%20-%20GitOps.md) for GitOps and [ADR 3](docs/adrs/3%20-%20ECS.md) for ECS specifics.

- 🔐 **Secure Database Password Handling**: Securely manages database passwords, avoiding plain text exposure. See [ADR 9](docs/adrs/9%20-%20Database%20Pasword%20Security.md).

- 🛡️ **Distroless Containers**: For production, uses distroless containers to minimize attack surfaces. See [ADR 5](docs/adrs/5%20-%20Distroless%20Container.md).

- 🔄 **GitOps Workflow**: Implements a GitOps workflow for secure and automated infrastructure deployment. See [ADR 2](docs/adrs/2%20-%20GitOps.md).

- 🔑 **Least Privilege Pipeline**: Ensures the CI/CD pipeline operates with the least privilege necessary, enhancing security. See [ADR 7](docs/adrs/7%20-%20Least%20Privileged%20pipeline%20with%20good%20DevEx.md).

- 🤖 **Machine-Generated Config Files**: Simplifies setup and ensures consistency with machine-generated HCL and JSON configuration files managed by Terraform. See [ADR 8](docs/adrs/8%20-%20Machine%20configuration%20files.md).


## Running with Docker Compose

### Step 1: Install Docker Compose

Follow the instructions [here](https://docs.docker.com/compose/install/) to install Docker Compose.

### Step 2: Start the Application

Run `docker-compose up --build` to start the application. This will:

- Build the application container.
- Start a PostgreSQL container.
- Start the application container.

### Step 3: Shut down the application

Run `docker-compose down --volumes` to shut down the application and remove the associated anonymous volumes.

## AWS Infrastructure Setup

You will need Terraform for this, which can be installed from the instructions here [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

### Setup / Initialize the `core` state

#### Quickstart

For full instructions including how to migrate to an S3 backend from an initial run (highly recommended), see the [README](iac/terraform/core/README.md) in the `iac/terraform/core` directory.

1. Copy the `.env.sh.dist` file to `.env.sh` and fill in the required values, then run:

    ```sh
    source .env.sh
    ```

2. Run terraform

    ```sh
    terraform init
    terraform apply
    ```

3. Copy `backend.tf.dist` to `backend.tf`; a `backend.hcl` should have been generated for you after your first apply, to now enable the S3 backend simply run:

    ```sh
    cp backend.tf.dist backend.tf
    terraform init -backend-config=backend.hcl
    ```
  

If this is not your first run, use `terraform init -backend-config=backend.hcl` if you're migrating to an S3 backend or using an existing one.

### Deploy the app with ECS & RDS

#### Quickstart

For full instructions including how to migrate to an S3 backend from an initial run (highly recommended), see the [README](iac/terraform/core/README.md) in the `iac/terraform/core` directory.

1. Copy the `.env.sh.dist` file to `.env.sh` and fill in the required values, then run:

    ```sh
    source .env.sh
    ```
2. After running the core setup, you should see 3 HCL files with backend configuration ready to go, navigate to the `iac/terraform/app` directory and run:

    ```sh
    chmod +x ./switch-backend.sh
    cp terraform.tfvars.json.dist terraform.tfvars.json
    ./switch-backend.sh dev
    ```

3. Run terraform

    ```sh

    terraform init
    terraform apply
    ```

    

## Running without a container

### Step 1: Clone the Repository

```
git clone https://github.com/shawnwollenberg/ipfs-metadata.git
cd nft_scraper
```

### Step 2: Set Up PostgreSQL
You can either set up PostgreSQL locally or use Docker to run it in a container.

Using Docker:

```
docker run --name postgres -e POSTGRES_USER=youruser -e POSTGRES_PASSWORD=yourpassword -e POSTGRES_DB=yourdb -p 5432:5432 -d postgres
```

### Step 3: Configure Environment Variables
Create a .env file (or copy and the .env.dist file) in the root directory of the project with the following content:

env
```
POSTGRES_USER=youruser
POSTGRES_PASSWORD=yourpassword
POSTGRES_DB=yourdb
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

### Step 4: Install Dependencies
```
go mod tidy
```

### Step 5: Prepare the CSV File
A CSV file has been saved in the `data` directory, but if you would like to add additional CIDs feel free to adjust. Each row should contain one CID.

### Step 6: Run the Application
```
go run .
```
This will:

* Read the CSV file.
* Fetch metadata for each CID from IPFS.
* Store the name and image fields in the PostgreSQL database.
* Start the API server.

### API Endpoints

#### Get All Metadata
##### Request:

```
GET /metadata
```

##### Response:
```
[
  {
    "cid": "Qm...",
    "name": "Example Name",
    "image": "Example Image URL"
  },
  ...
]
```

#### Get Metadata by CID
##### Request:

```GET /metadata/:cid```

##### Response:

```
{
  "cid": "Qm...",
  "name": "Example Name",
  "image": "Example Image URL"
}
```

## Acknowledgements
* [Gin Gonic](https://github.com/gin-gonic/gin) for the web framework.
* [sqlx](https://github.com/jmoiron/sqlx) for SQL database interactions.
* [godotenv](https://github.com/joho/godotenv) for loading environment variables from a .env file.

## Contact
For any questions or suggestions, please open an issue or contact the repository owner.