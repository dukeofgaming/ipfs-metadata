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
- Docker (for running PostgreSQL in a container, if desired)

## Setup

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

## Running with Docker Compose

### Step 1: Install Docker Compose

Follow the instructions [here](https://docs.docker.com/compose/install/) to install Docker Compose.

### Step 2: Start the Application

Run `docker-compose --build` to start the application. This will:

- Build the application container.
- Start a PostgreSQL container.
- Start the application container.

### Step 3: Shut down the application

Run `docker-compose down --volumes` to shut down the application and remove the associated anonymous volumes.

## AWS Infrastructure Setup

You will need Terraform for this, which can be installed from the instructions here [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

### Setup / Initialize the core state

Copy the `.env.sh.dist` file to `.env.sh` and fill in the values for your AWS account. Once you do that, `source .env.sh` to set the environment variables in your shell session.

Once you do that, run `terraform init` and `terraform apply` if it's your first run for a new set of environments (you will need to comment the `backend "s3" {}` block in `iac/terraform/environments/main.tf`).

If this is not your first run, use `terraform init -backend-config=backend.hcl` if you're migrating to an S3 backend or using an existing one.

For full instructions including how to migrate to an S3 backend from an initial run (highly recommended), see the [README](iac/terraform/environments/README.md) in the `iac/terraform/environments` directory.

## Acknowledgements
* [Gin Gonic](https://github.com/gin-gonic/gin) for the web framework.
* [sqlx](https://github.com/jmoiron/sqlx) for SQL database interactions.
* [godotenv](https://github.com/joho/godotenv) for loading environment variables from a .env file.

## Contact
For any questions or suggestions, please open an issue or contact the repository owner.