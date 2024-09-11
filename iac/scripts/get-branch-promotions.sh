#!/bin/sh

# Function to display usage
usage() {
    echo "Usage: $0 [-h|--help] file.json [branch_name]"
    echo ""
    echo "Arguments:"
    echo "  file.json           The JSON file to read promotion mappings from (required)."
    echo "  branch_name         The branch name to check for promotion (optional). If not provided, the current Git branch will be used."
    echo ""
    echo "Flags:"
    echo "  -h, --help          Show this help message and exit."
    exit 0
}

# Function to handle error when no promotion branch is found
error_exit() {
    echo "No promotion branch for '$1'"
    exit 1
}

# Function to handle error when no branch is found for reverse lookup
error_from_exit() {
    echo "No branch promotes to '$1'"
    exit 1
}

# Function to retrieve promotion branch for a given key
get_promotion() {
    branch="$1"
    jq_filter='.[$branch]'
    promotion=$(cat "$json_file" | jq -r --arg branch "$branch" "$jq_filter")
    
    if [ "$promotion" = "null" ] || [ -z "$promotion" ]; then
        error_exit "$branch"
    fi

    echo "$promotion"
}

# Function to match branch using glob patterns
match_branch() {
    branch="$1"
    cat "$json_file" | jq -r 'keys[]' | while read key; do
        case "$branch" in
            $key) echo "$key" && return 0 ;;
        esac
    done
    return 1
}

# Function to handle promotion lookup based on the branch or glob pattern
promotion_lookup() {
    branch="$1"
    matched_branch=$(match_branch "$branch")
    
    if [ -z "$matched_branch" ]; then
        error_exit "$branch"
    fi

    get_promotion "$matched_branch"
}

# Function to handle reverse lookup (finding branches that promote to the given one)
reverse_lookup() {
    branch="$1"
    jq_filter='to_entries | map(select(.value == $branch)) | map(.key) | join(",")'
    promotion_from=$(cat "$json_file" | jq -r --arg branch "$branch" "$jq_filter")

    if [ -z "$promotion_from" ]; then
        error_from_exit "$branch"
    fi

    echo "$promotion_from"
}

# Function to get the current Git branch
get_current_git_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Parse command line arguments
json_file=""
branch=""
help_flag=0

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            help_flag=1
            shift
            ;;
        *)
            if [ -z "$json_file" ]; then
                json_file="$1"
            else
                branch="$1"
            fi
            shift
            ;;
    esac
done

# Display help if -h or --help is passed
if [ "$help_flag" -eq 1 ]; then
    usage
fi

# Ensure a JSON file is supplied
if [ -z "$json_file" ]; then
    usage
fi

# If no branch is provided, get the current Git branch
if [ -z "$branch" ]; then
    branch=$(get_current_git_branch)
fi

# Commented out JSON map test data (kept for later use)
# json_map='{"dev":"main","main":"prod","prod":null,"*[0-9]-*":"dev","hotfix":"prod"}'

# Handle branch promotion logic or reverse lookup
result=$(promotion_lookup "$branch")

# Output result
echo "$result"