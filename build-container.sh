#!/bin/sh
set -e

build_context="."
version=""                  # Default to empty, meaning no version
commit=""                   # Default to ezmpty, meaning no commit
timestamp=""                # Default to empty, but will get Unix timestamp when -t is used
date=""                     # Default to empty, but will get current date and time when -d is used
architecture="linux/amd64"  # Default to linux/amd64
push_enabled=false          # Default to false for pushing images
docker_command=""           # Variable to store the Docker build command globally

# Function to extract the last segment of the ECR registry URL
get_last_segment() {
    echo "$1" | awk -F/ '{print $NF}'
}

# Function to get the name of the current directory
get_current_directory_name() {
    basename "$(pwd)"
}

# Function to parse arguments
parse_arguments() {
    image_name=""
    registry_ecr=""
    branch=""  # Variable to store the current git branch name

    while [ "$1" != "" ]; do
        case "$1" in
            -n | --name)
                shift
                image_name="$1"
                ;;
            -r | --registry-ecr)
                shift
                registry_ecr="$1"
                ;;
            -v | --version)
                shift
                version="$1"
                ;;
            -c | --commit)
                commit=$(git rev-parse --short HEAD)
                ;;
            -t | --timestamp)
                timestamp=$(date +%s)  # Get current Unix timestamp
                ;;
            -a | --architecture)
                shift
                architecture="$1"
                ;;
            -p | --push)
                push_enabled=true
                ;;
            -d | --date)
                date=$(date +%Y-%m-%d-%H-%M-%S)  # Get current date and time in specified format
                ;;
            -b | --branch)
                branch=$(git rev-parse --abbrev-ref HEAD)
                ;;
            -h | --help)
                usage
                exit 0
                ;;
            *)
                echo "Unknown argument: $1"
                exit 1
                ;;
        esac
        shift
    done

    # Use current directory name if no image name is provided
    if [ "$image_name" = "" ]; then
        image_name=$(get_current_directory_name)
    fi

    echo "$image_name" "$registry_ecr"
}

# Function to add tags for a given name
add_tags() {
    local name="$1"
    local tags="-t ${name}:latest"

    # If a version is provided, add a versioned tag
    [ "$version" != "" ] && tags="$tags -t ${name}:${version}"

    # If a commit is provided, add a commit hash tag
    [ "$commit" != "" ] && tags="$tags -t ${name}:${commit}"

    # If a timestamp is provided, add a timestamp tag
    [ "$timestamp" != "" ] && tags="$tags -t ${name}:${timestamp}"
    
    # If a date is provided, add a date tag
    [ "$date" != "" ] && tags="$tags -t ${name}:${date}"

    # If a branch name is provided, add a branch name tag
    [ "$branch" != "" ] && tags="$tags -t ${name}:${branch}"

    echo "$tags"
}

# Function to build the Docker command and store it in the global variable docker_command
build_docker_command() {
    local image_name="$1"
    local registry_ecr="$2"
    
    # Start with the Docker command and add the platform/architecture
    docker_command="docker build --platform ${architecture}"

    # Add tags for image name
    docker_command="$docker_command $(add_tags "$image_name")"

    # If ECR registry is provided, add its tags
    if [ "$registry_ecr" != "" ]; then
        docker_command="$docker_command $(add_tags "$registry_ecr")"

        # Add last segment of the ECR registry if different from image_name (used for build but not push)
        last_segment=$(get_last_segment "$registry_ecr")
        if [ "$last_segment" != "$image_name" ]; then
            docker_command="$docker_command $(add_tags "$last_segment")"
        fi
    fi

    # Add build context at the end
    docker_command="$docker_command $build_context"
}

# Function to perform Docker push after build, if enabled (only for registry_ecr tags)
docker_push() {
    local registry_ecr="$1"

    if [ "$push_enabled" = true ] && [ -n "$registry_ecr" ]; then
        echo "Pushing images to $registry_ecr..."

        docker push "${registry_ecr}:latest"
        [ "$version" != "" ] && docker push "${registry_ecr}:${version}"
        [ "$commit" != "" ] && docker push "${registry_ecr}:${commit}"
        [ "$timestamp" != "" ] && docker push "${registry_ecr}:${timestamp}"
        [ "$date" != "" ] && docker push "${registry_ecr}:${date}"
        [ "$branch" != "" ] && docker push "${registry_ecr}:${branch}"

        echo "Push complete."
    else
        echo "Push skipped. Either the push flag was not set or no ECR registry was provided."
    fi
}
# Function to login to ECR
ecr_login() {
    local registry_ecr="$1"
    # Extract the region from the ECR URL
    local region=$(echo "$registry_ecr" | awk -F'.' '{print $4}')
    # Remove the last segment to get the base URL
    local base_url=$(echo "$registry_ecr" | awk -F'/' '{sub(/\/[^\/]+$/, "", $0); print $0}')
    
    echo "
    Logging in to ECR registry $base_url in region $region...
    "

    aws ecr get-login-password --region "$region" \
        | docker login --username AWS --password-stdin "$base_url"
}

# Function to print all arguments and options for debugging
print_debug_info() {
    echo "
    ==============================
    ======== DEBUG INFO ==========
    ==============================
    Image Name: $image_name
    Registry (ECR): $registry_ecr
    Version: $version
    Commit: $commit
    Timestamp: $timestamp
    Branch: $branch

    Architecture: $architecture
    Push Enabled: $push_enabled
    ==============================
    "
}

# Function to display usage information
usage() {
    echo "Usage: $0 [OPTIONS]

    Options:
      -n, --name            Set the image name
      -r, --registry-ecr    Set the ECR registry URL
      -v, --version         Set the image version
      -c, --commit          Use the current git commit hash as a tag
      -b, --branch          Use the current git branch as a tag
      -t, --timestamp       Use the current timestamp as a tag
      -a, --architecture    Set the build architecture (default: linux/amd64)
      -p, --push            Enable pushing the image to the registry
      -d, --date            Use the current date and time as a tag
      -h, --help            Display this help message and exit
    "
}

# Main function to run the script logic
main() {
    parse_arguments "$@"  # Parse arguments and set variables
    # Login to ECR if registry URL is provided
    if [ -n "$registry_ecr" ]; then
        ecr_login "$registry_ecr"
    fi
    
    # Print debug info
    print_debug_info
    
    # Build the Docker command (this sets the global docker_command variable)
    build_docker_command "$image_name" "$registry_ecr"

    # Output the full Docker build command for logging/debugging
    echo "Docker build command: $docker_command"

    # Execute the Docker build command
    eval "$docker_command"

    # If build is successful, invoke Docker push if the push flag is set
    if [ $? -eq 0 ]; then
        docker_push "$registry_ecr"
    else
        echo "Docker build failed, skipping push."
    fi
}

# Run the script
main "$@"