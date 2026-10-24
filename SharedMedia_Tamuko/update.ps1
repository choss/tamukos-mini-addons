# Script to download and update SharedMedia_Template from GitHub

$url = "https://github.com/Nnoggie/SharedMedia_Template/archive/refs/heads/main.zip"
$zipFile = Join-Path $PSScriptRoot "SharedMedia_Template-main.zip"
$extractPath = $PSScriptRoot

Write-Host "Downloading SharedMedia_Template from GitHub..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $url -OutFile $zipFile -UseBasicParsing
    Write-Host "Download complete!" -ForegroundColor Green
} catch {
    Write-Host "Error downloading file: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Extracting files..." -ForegroundColor Cyan
try {
    # Extract to a temporary location first
    $tempExtract = Join-Path $PSScriptRoot "temp_extract"
    Expand-Archive -Path $zipFile -DestinationPath $tempExtract -Force
    
    # Move files from the extracted subdirectory to the current directory
    $extractedFolder = Join-Path $tempExtract "SharedMedia_Template-main"
    if (Test-Path $extractedFolder) {
        Get-ChildItem -Path $extractedFolder -Recurse | ForEach-Object {
            $targetPath = $_.FullName -replace [regex]::Escape($extractedFolder), $extractPath
            if ($_.PSIsContainer) {
                if (-not (Test-Path $targetPath)) {
                    New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
                }
            } else {
                Copy-Item -Path $_.FullName -Destination $targetPath -Force
                Write-Host "  Copied: $($_.Name)" -ForegroundColor Gray
            }
        }
    }
    
    # Clean up temporary extraction directory
    Remove-Item -Path $tempExtract -Recurse -Force
    Write-Host "Extraction complete!" -ForegroundColor Green
} catch {
    Write-Host "Error extracting files: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Cleaning up..." -ForegroundColor Cyan
Remove-Item -Path $zipFile -Force
Write-Host "Update complete! SharedMedia_Template has been downloaded and extracted." -ForegroundColor Green
