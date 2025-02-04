#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigate to that directory
cd "$SCRIPT_DIR" || { echo "Failed to navigate to script directory!"; exit 1; }

# Define output file
OUTPUT_FILE="nvim_config_tree.txt"
> "$OUTPUT_FILE"  # Clear previous output

# Add directory structure to the output file
echo "📂 NeoVim Configuration Tree ($SCRIPT_DIR):" >> "$OUTPUT_FILE"
tree -a -I "node_modules|.git|plugged|undodir" >> "$OUTPUT_FILE"

# Add contents of all relevant config files
echo -e "\n🔍 NeoVim Config Files Contents:\n" >> "$OUTPUT_FILE"

# Find and print all Lua and Vimscript files
find . -type f \( -name "*.lua" -o -name "*.vim" -o -name "init.vim" -o -name "init.lua" \) | while read -r file; do
    echo -e "\n--- File: $file ---\n" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
done

# Inform the user
echo "✅ NeoVim configuration details saved to $OUTPUT_FILE"
