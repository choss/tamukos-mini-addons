#!/bin/bash

# Configuration
PACKAGE_SCRIPT="./package.sh"

# Check if zip is installed
if ! command -v zip &> /dev/null; then
    echo "Error: 'zip' command not found. Please install it (e.g. 'sudo apt install zip' or use Git Bash)."
    exit 1
fi

# Ensure package script is executable
chmod +x "$PACKAGE_SCRIPT" 2>/dev/null

echo "=== WoW Addon Release Helper ==="
echo "This script will update the .toc versions and package your addons."
echo ""

# Mode Selection
read -p "Is this a Pre-Release (Nightly)? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    IS_PRERELEASE=true
    VERSION="nightly"
    echo "Mode: PRE-RELEASE (No version bump, no permanent git tags)"
else
    IS_PRERELEASE=false
    # 1. Prompt for Version
    echo "Enter the new version number (e.g., 1.0.5) or press Enter to skip version bump:"
    read -r VERSION
fi

if [[ "$IS_PRERELEASE" == "false" && -n "$VERSION" ]]; then
    # Validate version format (simple check)
    if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
        echo "Warning: '$VERSION' does not look like a standard semantic version (x.y.z)."
        echo "Continuing anyway..."
    fi

    echo "Updating .toc files..."
    
    # Find all TOC files in direct subdirectories (depth 2 matches ./Addon/Addon.toc)
    # Using a temporary file approach for maximum compatibility (BSD/GNU sed differences)
    find . -maxdepth 2 -name "*.toc" | while read -r toc_file; do
        # Create temp file
        tmp_file="${toc_file}.tmp"
        
        # Replace Version line
        # Logic: Look for lines starting with "## Version:", replace mostly the whole line
        sed "s/^## Version:.*/## Version: $VERSION/" "$toc_file" > "$tmp_file"
        
        # Move back
        mv "$tmp_file" "$toc_file"
        echo "  Updated $toc_file"
    done
    
    echo "Version update complete."

    # Git Integration
    if command -v git &> /dev/null; then
        echo "Creating Git tag..."
        
        # Add modified TOC files
        git add */*.toc
        
        # Commit
        git commit -m "Release v$VERSION"
        
        # Tag
        git tag "v$VERSION"
        
        echo "Tagged v$VERSION"
    else
        echo "Git not found, skipping tag creation."
    fi
else
    echo "Skipping version update / TOC modification."
fi

echo ""
echo "=== Packaging Addons ==="

# 2. Run the existing package script
if [ -f "$PACKAGE_SCRIPT" ]; then
    bash "$PACKAGE_SCRIPT"
else
    echo "Error: $PACKAGE_SCRIPT not found!"
    exit 1
fi

echo ""
echo "=== Done! ==="
echo "Artifacts are in the 'dist/' folder."

echo ""
read -p "Do you want to Push & Release to GitHub? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pushing changes..."
    # Always push code
    git push

    if command -v gh &> /dev/null; then
        if [[ "$IS_PRERELEASE" == "true" ]]; then
            echo "Handling Nightly Release..."
            # Clean up old nightly if exists
            echo "Cleaning up old 'nightly' tag..."
            gh release delete nightly -y --cleanup-tag 2>/dev/null || echo "No previous nightly found to delete."
            
            # Create new nightly
            echo "Uploading new 'nightly' release..."
            # Target current branch
            CURRENT_BRANCH=$(git branch --show-current)
            gh release create nightly dist/*.zip --prerelease --title "Nightly Build $(date +'%Y-%m-%d')" --notes "Automated nightly build." --target "$CURRENT_BRANCH"
            
        elif [[ -n "$VERSION" ]]; then
            echo "Pushing tags..."
            git push --tags
            echo "Creating GitHub Release v$VERSION..."
            gh release create "v$VERSION" dist/*.zip --title "v$VERSION" --generate-notes
        else
            echo "Warning: No version set and not in pre-release mode."
            echo "Skipping automatic release creation."
        fi
    else
        echo "Warning: 'gh' (GitHub CLI) not found. Cannot create release automatically."
    fi
else
    echo "Recommended: Create a new Release on GitHub and attach these zip files."
fi

