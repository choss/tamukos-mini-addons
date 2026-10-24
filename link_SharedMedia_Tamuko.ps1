$AddonName = "SharedMedia_Tamuko"
$SourcePath = Join-Path $PSScriptRoot $AddonName

Write-Host "Detected Addon Source: $SourcePath" -ForegroundColor Cyan

# list of common paths to check
$CommonPaths = @(
    "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns",
    "C:\Program Files\World of Warcraft\_retail_\Interface\AddOns",
    "G:\\Blizzard\World of Warcraft\_retail_\Interface\AddOns",
    "D:\World of Warcraft\_retail_\Interface\AddOns",
    "E:\World of Warcraft\_retail_\Interface\AddOns"
)

$TargetAddonsPath = $null

foreach ($path in $CommonPaths) {
    if (Test-Path $path) {
        $TargetAddonsPath = $path
        break
    }
}

if (-not $TargetAddonsPath) {
    Write-Host "Could not automatically find WoW directory." -ForegroundColor Yellow
    $TargetAddonsPath = Read-Host "Please paste your 'World of Warcraft\_retail_\Interface\AddOns' path here"
}

if (-not (Test-Path $TargetAddonsPath)) {
    Write-Error "Target path does not exist: $TargetAddonsPath"
    exit 1
}

$DestPath = Join-Path $TargetAddonsPath $AddonName

if (Test-Path $DestPath) {
    Write-Warning "Destination folder already exists: $DestPath"
    $response = Read-Host "Delete existing folder and link? (y/n)"
    if ($response -eq 'y') {
        Remove-Item -Path $DestPath -Recurse -Force
    } else {
        exit
    }
}

New-Item -ItemType Junction -Path $DestPath -Target $SourcePath
Write-Host "Success! Linked $AddonName to WoW." -ForegroundColor Green
