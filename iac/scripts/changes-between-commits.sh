#!/bin/sh

#TODO: Delete, not worth the trouble

# Function to show usage
usage() {
  echo "Usage: $0 --start-from <commit|branch|tag> --end-at <commit|branch|tag>"
  echo "If only one flag is provided, the current commit will be used for the other."
  exit 1
}

# Function to get the current commit if missing
get_commit() {
  if [ -z "$1" ]; then
    git rev-parse HEAD
  else
    echo "$1"
  fi
}

# Function to determine if the range signifies a rollback
is_rollback() {
  start_date=$(git log -1 --pretty=format:"%ct" "$1")
  end_date=$(git log -1 --pretty=format:"%ct" "$2")
  
  if [ "$end_date" -lt "$start_date" ]; then
    return 0  # It's a rollback (end is older)
  else
    return 1  # Not a rollback (end is newer)
  fi
}

# Function to get the branch name for a commit
get_branch_name() {
  ref="$1"
  branch=$(echo "$ref" | grep -oE 'HEAD -> [^,)]+' | sed 's/HEAD -> //')
  
  if [ -z "$branch" ]; then
    branch=$(git name-rev --name-only "$commit" 2>/dev/null)
  fi
  
  echo "$branch"
}

# Function to get the tags for a commit
get_tags() {
  commit="$1"
  tags=$(git tag --contains "$commit" | tr '\n' ',' | sed 's/,$//')
  
  if [ -z "$tags" ]; then
    tags="none"
  fi
  
  echo "$tags"
}

# Function to format a commit entry
format_commit_entry() {
  commit="$1"
  ref="$2"
  date="$3"
  author="$4"
  message="$5"
  rollback="$6"

  branch=$(get_branch_name "$ref")
  tags=$(get_tags "$commit")
  
  line="- **[$commit@$branch] $date by $author**: $message (*$tags*)"
  
  if [ "$rollback" = "true" ]; then
    line="~~$line~~"
  fi
  
  echo "$line"
}

# Main function to process commits and display the log
process_commits() {
  start_commit="$1"
  end_commit="$2"
  rollback="$3"

  git log \
    --pretty=format:"%H|%d|%cd|%an|%s" \
    --date=format:"%Y/%m/%d %H:%M:%S" \
    "$start_commit..$end_commit" | while IFS='|' read -r commit ref date author message; do
      format_commit_entry "$commit" "$ref" "$date" "$author" "$message" "$rollback"
  done
}

# Main script logic

# Initialize variables
start_from=""
end_at=""

# Parse command-line arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --start-from)
      start_from="$2"
      shift 2
      ;;
    --end-at)
      end_at="$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

# Set default commit values if needed
start_from=$(get_commit "$start_from")
end_at=$(get_commit "$end_at")

# Determine if it's a rollback
rollback="false"
if is_rollback "$start_from" "$end_at"; then
  echo "
  Detected rollback scenario: The changes are being rolled back.
  "
  rollback="true"
  
  # Swap start_from and end_at for git log to work correctly
  temp="$start_from"
  start_from="$end_at"
  end_at="$temp"
else
  echo "
  New changes are being added:
  "
fi

# Generate commit messages
echo "Commit messages between $start_from and $end_at:"
process_commits "$start_from" "$end_at" "$rollback"