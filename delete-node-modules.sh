#!/bin/bash

# Script to find and delete node_modules directories that haven't been accessed in a specified number of days
# Shows only the main project directories containing these node_modules

# Function to show help
show_help() {
    echo "Usage: $(basename "$0") [DIRECTORY] [DAYS] [OPTIONS]"
    echo ""
    echo "Find and delete node_modules directories that haven't been accessed in a specified number of days."
    echo ""
    echo "Options:"
    echo "  --help      Show this help message and exit"
    echo ""
    echo "Arguments:"
    echo "  DIRECTORY   Starting directory to search from (default: current directory)"
    echo "  DAYS        Number of days since last access (default: 45)"
    echo ""
    echo "Example:"
    echo "  $(basename "$0") ~/projects 30    # Search in ~/projects for node_modules not accessed in 30 days"
    echo "  $(basename "$0")                  # Search in current directory with default 45 days"
    exit 0
}

# Check for help option
if [[ "$1" == "--help" ]]; then
    show_help
fi

# Get the starting directory from the user or use the current directory
start_dir="${1:-.}"
# Get number of days from second parameter or use default value of 45
days="${2:-45}"

echo "Searching for projects with unused node_modules directories..."
echo "Starting from: $(cd "$start_dir" && pwd)"
echo "This will find node_modules directories not accessed in the last $days days."
echo ""

# Create a temporary file to store unique project directories
temp_file=$(mktemp)

# Find top-level node_modules directories not accessed in more than specified days
# Using a regex to match only direct node_modules folders, not nested ones
find "$start_dir" -type d -path "*/node_modules" -not -path "*/node_modules/*/node_modules*" -atime +$days -print0 | while IFS= read -r -d '' dir; do
    # Get the parent directory of node_modules (the project directory)
    project_dir=$(dirname "$dir")
    
    # Calculate size of the node_modules directory
    size=$(du -sh "$dir" 2>/dev/null | cut -f1)
    
    # Store the project directory and size
    echo "$project_dir|$size" >> "$temp_file"
done

# Display the unique project directories
sort -u "$temp_file" | while IFS="|" read -r project size; do
    echo "Found: $project (Size: $size)"
done

echo ""
echo "Review the list above. Do you want to delete node_modules in these projects? (y/N)"
read -r confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
    echo "Deleting node_modules directories..."
    sort -u "$temp_file" | while IFS="|" read -r project size; do
        node_modules_dir="$project/node_modules"
        if [ -d "$node_modules_dir" ]; then
            echo "Deleting: $node_modules_dir"
            rm -rf "$node_modules_dir"
        fi
    done
    echo "Done! Space has been freed."
else
    echo "Operation cancelled. No directories were deleted."
fi

# Clean up temp file
rm -f "$temp_file"
