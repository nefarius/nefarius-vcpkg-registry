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

# --- Update ports/neflib/portfile.cmake (SHA512) and ports/neflib/vcpkg.json (version) ---
# Both files are edited via targeted regex replacement (not ConvertTo-Json round-trips) so
# formatting stays stable and both changes land in the *same* commit before we snapshot the
# "git-tree" below. Previously the version bump happened after this snapshot was taken and was
# never staged for the amend, so published versions could end up with a stale manifest version.

$cmakeFilePath = ".\ports\neflib\portfile.cmake"
$cmakeContent = Get-Content -Raw -Path $cmakeFilePath
$cmakeContent = $cmakeContent -replace "(SHA512)\s+[0-9a-fA-F]{128}", "`$1 $customSHA512"
Set-Content -NoNewline -Path $cmakeFilePath -Value $cmakeContent

$manifestPath = ".\ports\neflib\vcpkg.json"
$manifestContent = Get-Content -Raw -Path $manifestPath
$manifestContent = $manifestContent -replace '("version":\s*)"[^"]+"', "`$1""$RefVersion"""
Set-Content -NoNewline -Path $manifestPath -Value $manifestContent

git add ports/neflib/portfile.cmake ports/neflib/vcpkg.json
git commit -m "Updated neflib" *> $null
$commitSHA1 = $(git rev-parse HEAD:ports/neflib)

# --- Update versions/baseline.json (scoped to the neflib block, preserves formatting) ---
$baselinePath = ".\versions\baseline.json"
$baselineContent = Get-Content -Raw -Path $baselinePath
$baselineContent = $baselineContent -replace '("neflib":\s*\{\s*"baseline":\s*)"[^"]+"', "`$1""$RefVersion"""
Set-Content -NoNewline -Path $baselinePath -Value $baselineContent

# --- Update versions/n-/neflib.json (insert new entry or refresh git-tree of an existing one) ---
$jsonFilePath = ".\versions\n-\neflib.json"
$jsonContent = Get-Content -Raw -Path $jsonFilePath

if ($jsonContent -match "`"version`":\s*`"$([regex]::Escape($RefVersion))`"") {
    # Version already registered (re-run for the same tag): just refresh its git-tree.
    $jsonContent = $jsonContent -replace "(`"version`":\s*`"$([regex]::Escape($RefVersion))`",\s*\r?\n\s*`"git-tree`":\s*)`"[^`"]+`"", "`$1`"$commitSHA1`""
}
else {
    # New version: prepend an entry right after the opening "versions": [ bracket.
    $newEntry = "    {`r`n      `"version`": `"$RefVersion`",`r`n      `"git-tree`": `"$commitSHA1`"`r`n    },`r`n"
    $jsonContent = $jsonContent -replace '("versions":\s*\[\r?\n)', "`$1$newEntry"
}

Set-Content -NoNewline -Path $jsonFilePath -Value $jsonContent

# Delete the temporary file
Remove-Item -Path $localFile -Force

git add versions
git commit --amend --no-edit *> $null
git push *> $null
$baseline = $(git rev-parse HEAD)

"New baseline: " + $baseline
