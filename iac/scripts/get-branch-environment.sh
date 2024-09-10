#!/bin/sh

# Usage function to display script usage instructions
usage() {
  echo "Usage: $0 <json_file> [branch_name]"
  echo "  <json_file>    Required: Path to the JSON file containing the branch-to-environment map."
  echo "  [branch_name]  Optional: Name of the branch. If not provided, the script uses the current branch."
  exit 1
}

# Check if at least one argument (JSON file) is provided
if [ $# -lt 1 ]; then
  usage
fi

# Set variables based on arguments
json_file="$1"
branch="${2:-$(git rev-parse --abbrev-ref HEAD)}"  # If branch is not provided, use the current git branch

# Check if the JSON file exists
if [ ! -f "$json_file" ]; then
  echo "Error: JSON file '$json_file' does not exist."
  exit 1
fi

# Function to find a matching environment for the current branch
find_environment_and_workspace() {
  map_file=$1
  branch=$2

  # Use jq to find the matching environment template for the current branch
  env_template=$(jq -r --arg branch "$branch" '
    to_entries | map(select(.key | test($branch))) | .[0].value' "$map_file")

  # Check if a match was found
  if [ "$env_template" = "null" ] || [ -z "$env_template" ]; then
    echo "No match found for branch: $branch"
    return 1
  fi

  # Extract the environment (first part before '/')
  environment=$(echo "$env_template" | cut -d'/' -f1)

  # Extract the Terraform workspace if applicable, otherwise set it to "default"
  case "$env_template" in
    *"{terraform.workspace}"*)
      terraform_workspace="$branch"
      ;;
    *)
      terraform_workspace="default"
      ;;
  esac

  # Export TF_WORKSPACE so that it is available if the script is sourced
  export TF_WORKSPACE="$terraform_workspace"

  # Output the environment as a JSON array with one element (but don't echo TF_WORKSPACE)
  echo "[\"$environment\"]"
}

# Call the function with the provided JSON file and branch
find_environment_and_workspace "$json_file" "$branch"