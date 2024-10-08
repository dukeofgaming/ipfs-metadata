#!/bin/sh

# Usage function for the main script
usage() {
  echo "Usage: $0 {tag|find} [options]"
  echo ""
  echo "Subcommands:"
  echo "  tag   Create and push a tag."
  echo "  find  Find and list tags."
  echo ""
  echo "Use '$0 tag --help' or '$0 find --help' for subcommand-specific options."
  exit 1
}

# Usage function for the 'tag' subcommand
usage_tag() {
  echo "Usage: $0 tag [options]"
  echo "Options:"
  echo "  -d, --date [date]     (Optional) Tag with the specified date. If no date is provided, the current date/time is used (format: YYYY/MM/DD/HH_mm_ss)."
  echo "  -c, --current         Update the 'deploy/<branch>/current' tag to the specified deployment."
  echo "  --dry-run             Print the commands instead of executing them."
  echo "  -h, --help            Show this help message."
  exit 1
}

# Usage function for the 'find' subcommand
usage_find() {
  echo "Usage: $0 find [options]"
  echo "Options:"
  echo "  -d, --date [date]     Find tags matching the specified date. If no date is provided, return all tags."
  echo "  -c, --current         Find the current deployment tag."
  echo "  --dry-run             Print the commands instead of executing them."
  echo "  -h, --help            Show this help message."
  exit 1
}

# Function to create and push tags with the specified options
tag() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  date_flag=""
  current_flag="false"
  dry_run="false"
  date_provided="false"

  # If no options are passed, show usage
  if [ $# -eq 0 ]; then
    usage_tag
  fi

  # Parse options
  while [ $# -gt 0 ]; do
    case "$1" in
      -d|--date)
        date_provided="true"
        # If the next argument starts with "-" or is absent, use the current date/time
        if [ -z "$2" ] || [ "${2#-}" != "$2" ]; then
          date_flag=$(date "+%Y/%m/%d/%H-%M-%S")
        else
          # Use the provided date
          date_flag="$2"
          shift
        fi
        ;;
      -c|--current)
        current_flag="true"
        ;;
      --dry-run)
        dry_run="true"
        ;;
      -h|--help)
        usage_tag
        ;;
      *)
        echo "Invalid option: $1" >&2
        usage_tag
        ;;
    esac
    shift
  done

  # If --date is provided without a value, generate a date, otherwise don't generate one
  if [ "$date_provided" = "false" ]; then
    date_flag=""
  fi

  # If no date is provided and no --date flag is used, use the current date/time
  if [ -n "$date_flag" ]; then
    tag_name="deploy/${branch}/${date_flag}"
  else
    tag_name=""
  fi

  current_tag="deploy/${branch}/current"

  # Print commands instead of executing them if --dry-run is specified
  if [ "$dry_run" = "true" ]; then
    if [ -n "$tag_name" ]; then
      echo "git tag $tag_name"
      echo "git push origin $tag_name"
    fi
    if [ "$current_flag" = "true" ]; then
      echo "git tag -f $current_tag"
      echo "git push origin -f $current_tag"
    fi
  else
    # Create the date-based tag and push it if a date tag was provided
    if [ -n "$tag_name" ]; then
      git tag "$tag_name"
      git push origin "$tag_name"
      echo "Tag created and pushed: $tag_name"
    fi

    # Update the 'deploy/<branch>/current' tag if --current is specified
    if [ "$current_flag" = "true" ]; then
      git tag -f "$current_tag"
      git push origin -f "$current_tag"
      echo "'$current_tag' tag updated and pushed"
    fi
  fi
}

# Function to find tags based on options
find_tags() {
  filter="latest"
  dry_run="false"

  # Parse options
  while [ $# -gt 0 ]; do
    case "$1" in
      -d|--date)
        if [ -z "$2" ]; then
          filter="*"
        else
          filter="*$2*"
          shift
        fi
        shift
        ;;
      -c|--current)
        branch=$(git rev-parse --abbrev-ref HEAD)
        filter="deploy/${branch}/current"
        shift
        ;;
      --dry-run)
        dry_run="true"
        shift
        ;;
      -h|--help)
        usage_find
        ;;
      *)
        echo "Invalid option: $1" >&2
        usage_find
        ;;
    esac
  done

  # Print the command in dry-run mode
  if [ "$dry_run" = "true" ]; then
    echo "git tag -l '$filter'"
  else
    # Actually list the matching tags
    git tag -l "$filter"
  fi
}

# Main script logic
case "$1" in
  tag)
    shift
    tag "$@"
    ;;
  find)
    shift
    find_tags "$@"
    ;;
  *)
    usage
    ;;
esac