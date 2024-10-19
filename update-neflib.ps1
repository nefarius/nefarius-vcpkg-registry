Param(
    [Parameter(Mandatory = $true)]
    [string]$Version
) #end param

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed or not available in the system PATH."
    exit
}

# Define the URL and the local file path
$url = "https://github.com/nefarius/neflib/archive/refs/tags/v$Version.tar.gz"
$localFile = "$env:TEMP\v$Version.tar.gz"

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

# Define the path to the JSON file
$jsonFilePath = ".\versions\n-\neflib.json"

# Read the JSON file content
$jsonContent = Get-Content -Raw -Path $jsonFilePath | ConvertFrom-Json

# Update the git-tree value
foreach ($version in $json.versions) {
    if ($version.version -eq $Version) {
        $version.'git-tree' = $commitSHA1
        break
    }
}

# Convert the updated object back to JSON format
$updatedJsonContent = $jsonContent | ConvertTo-Json -Depth 10

# Write the updated JSON back to the file
Set-Content -Path $jsonFilePath -Value $updatedJsonContent

# Delete the temporary file
Remove-Item -Path $localFile -Force

git add versions *> $null
git commit --amend --no-edit *> $null
git push *> $null
$baseline = $(git rev-parse HEAD)

"New baseline: " + $baseline
