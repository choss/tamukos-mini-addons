#!/bin/bash

# Configuration
DIST_DIR="dist"

# Create output directory
mkdir -p "$DIST_DIR"

# Initialize array for valid addons
valid_addons=()

# Loop through all subdirectories in the current folder
for dir in */; do
    # Remove trailing slash to get the folder name
    addon_name=${dir%/}
    
    # Check if this folder is a WoW addon (contains a .toc file with the same name)
    if [ -f "$addon_name/$addon_name.toc" ]; then
        echo "Packaging $addon_name..."
        
        # Create the zip file in the dist folder
        # We exclude hidden system files and git artifacts
        zip -r -q "$DIST_DIR/$addon_name.zip" "$addon_name" -x "*.git*" "*.DS_Store" "*Thumbs.db"

        # Add to list of valid addons
        valid_addons+=("$addon_name")
    fi
done

# Create combined zip if we found any addons
if [ ${#valid_addons[@]} -gt 0 ]; then
    echo "Creating combined collection..."
    zip -r -q "$DIST_DIR/Tamukos-Addon-Collection.zip" "${valid_addons[@]}" -x "*.git*" "*.DS_Store" "*Thumbs.db"
    echo "Created collection: $DIST_DIR/Tamukos-Addon-Collection.zip"
fi

echo "-----------------------------------"
echo "Build complete!"
echo "Addons packaged in: $DIST_DIR/"
