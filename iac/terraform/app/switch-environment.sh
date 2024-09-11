#!/bin/sh
usage() {
    echo "Usage: $0 <environment-name>"
    echo "Example: $0 staging"
    exit 1
}

# Validate that an environment name is passed
if [ "$#" -ne 1 ]; then
    usage
fi

# Check if terraform.tfvars.json exists, if not, copy the .dist file
if [ ! -f "terraform.tfvars.json" ]; then
  cp terraform.tfvars.json.dist terraform.tfvars.json
fi

backend_file="backend-$1.hcl"

# Do a terraform init -reconfigure -backend-config=backend-<environment>.tfvars 
# using the passed environment name, do so only if the backend config file exists
if [ -f "$backend_file" ]; then

    echo "Switching to environment '$1' using backend config file: $backend_file"
  
    # Execute terraform init, and only if it succeeds modify the terraform.tfvars.json file with jq
    terraform init -reconfigure -backend-config="$backend_file"

    if [ $? -eq 0 ]; then
        
        # Update the environment value in terraform.tfvars.json without replacing the entire file
        jq \
            --arg env "$1" \
            '.environment = $env' \
            terraform.tfvars.json > temp.json \
                && mv temp.json terraform.tfvars.json

        echo "Switched to environment: $1"
    else
        echo "Error: Terraform init failed."
        exit 1
    fi

else
    echo "Error: backend-$1.tfvars file does not exist."
    exit 1
fi