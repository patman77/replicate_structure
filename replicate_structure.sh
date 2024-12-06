#!/bin/bash

# Function to display usage information
usage() {
    echo "Description:"
    echo "  This script replicates a specific folder structure or copies matching folders"
    echo "  (and their contents, optionally) from the source directory to the destination directory."
    echo "  It only includes subdirectories matching the specified pattern."
    echo
    echo "Usage:"
    echo "  $0 <source_dir> <destination_dir> <pattern> [--copy]"
    echo
    echo "Arguments:"
    echo "  <source_dir>       The source directory to copy from."
    echo "  <destination_dir>  The destination directory to copy to."
    echo "  <pattern>          The folder name pattern to match (e.g., 'yuv*')."
    echo "  --copy             (Optional) If specified, the script copies matching subfolders"
    echo "                     and their contents. If omitted, it only replicates the folder structure."
    echo
    echo "Example:"
    echo "  $0 /path/to/src /path/to/dst 'yuv*' --copy"
    echo
    echo "Behavior:"
    echo "  - Searches the <source_dir> for directories that match <pattern>."
    echo "  - By default, replicates the directory structure of matching folders into <destination_dir>."
    echo "  - If '--copy' is specified, also copies the contents of matching subfolders."
    exit 1
}

# Check if at least 3 parameters are provided
if [ "$#" -lt 3 ]; then
    usage
fi

# Assign command-line arguments to variables
SRC_DIR="$1"
DST_DIR="$2"
PATTERN="$3"
COPY_CONTENTS=false

# Check if "--copy" flag is provided
if [ "$#" -eq 4 ] && [ "$4" == "--copy" ]; then
    COPY_CONTENTS=true
fi

# Check if the source directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory '$SRC_DIR' does not exist."
    exit 1
fi

# Create the destination directory if it doesn't exist
mkdir -p "$DST_DIR"

# Use find to locate folders matching the pattern
find "$SRC_DIR" -type d -name "$PATTERN" | while read -r src_path; do
    # Compute the relative path
    relative_path="${src_path#$SRC_DIR/}"
    
    # Construct the destination path
    dst_path="$DST_DIR/$relative_path"
    
    # Create the destination directory (parent directory)
    mkdir -p "$(dirname "$dst_path")"
    
    if [ "$COPY_CONTENTS" = true ]; then
        # Copy the matching folder and its contents
        echo "Copying: $src_path -> $dst_path"
        cp -r "$src_path" "$dst_path"
    else
        # Only replicate the folder structure
        echo "Creating: $dst_path"
        mkdir -p "$dst_path"
    fi
done

echo "Operation complete!"

