Param(
    [Parameter(Mandatory = $true)]
    [string]$RefVersion
) #end param

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed or not available in the system PATH."
    exit
}

# Define the URL and the local file path
$url = "https://github.com/nefarius/neflib/archive/refs/tags/v$RefVersion.tar.gz"
$localFile = "$env:TEMP\v$RefVersion.tar.gz"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $localFile

# Compute the SHA512 hash
$sha512 = Get-FileHash -Algorithm SHA512 -Path $localFile

$customSHA512 = $sha512.Hash

# Define the path to the .cmake file
$cmakeFilePath = ".\ports\neflib\portfile.cmake"

# Read the content of the .cmake file
$fileContent = Get-Content $cmakeFilePath

# Define a regex pattern to match the existing SHA512 line
$pattern = "(SHA512)\s+[0-9a-fA-F]{128}"

# Replace the old SHA512 value with your custom one
$updatedContent = $fileContent -replace $pattern, "`$1 $customSHA512"

# Write the updated content back to the file
Set-Content $cmakeFilePath -Value $updatedContent

git commit -a -m "Updated neflib" *> $null
$commitSHA1 = $(git rev-parse HEAD:ports/neflib)

$manifestPath = ".\ports\neflib\vcpkg.json"

$manifest = Get-Content -Raw -Path $manifestPath | ConvertFrom-Json

$manifest.version = "$RefVersion";

Set-Content -Path $manifestPath -Value $($manifest | ConvertTo-Json -Depth 10)

$baselinePath = ".\versions\baseline.json"

$baselineJson = Get-Content -Raw -Path $baselinePath | ConvertFrom-Json

$baselineJson.default.neflib.baseline = "$RefVersion";

Set-Content -Path $baselinePath -Value $($baselineJson | ConvertTo-Json -Depth 10)

# Define the path to the JSON file
$jsonFilePath = ".\versions\n-\neflib.json"

# Read the JSON file content
$json = Get-Content -Raw -Path $jsonFilePath | ConvertFrom-Json

$version = $json.versions | Where-Object { $_.version -eq $RefVersion }

if ($version) {
    # Update the existing version's "git-tree"
    $version.'git-tree' = $commitSHA1
}
else {
    # Add a new version with the specified "git-tree"
    $newRefVersion = [PSCustomObject]@{
        version    = $RefVersion
        'git-tree' = $commitSHA1
    }
    $json.versions += $newRefVersion
}

# Convert the updated object back to JSON format
$updatedJsonContent = $json | ConvertTo-Json -Depth 10

# Write the updated JSON back to the file
Set-Content -Path $jsonFilePath -Value $updatedJsonContent

# Delete the temporary file
Remove-Item -Path $localFile -Force

git add versions *> $null
git commit --amend --no-edit *> $null
git push *> $null
$baseline = $(git rev-parse HEAD)

"New baseline: " + $baseline
