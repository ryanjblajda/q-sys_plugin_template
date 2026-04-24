param(
    [string]$File,
    [string]$Mode = "patch"
)

$content = Get-Content $File -Raw

# ---- VERSION MATCH ----
if ($content -notmatch 'Version\s*=\s*["''](\d+)\.(\d+)\.(\d+)["'']') {
    throw "No Version = X.Y.Z found in $File"
}

$major = [int]$matches[1]
$minor = [int]$matches[2]
$patch = [int]$matches[3]

# ---- BUILD MATCH (optional) ----
$buildMatch = [regex]::Match($content, 'Build(?:Version)?\s*=\s*["'']?(\d+)["'']?')
if ($buildMatch.Success) {
    $build = [int]$buildMatch.Groups[1].Value
} else {
    $build = 0
}

switch ($Mode) {

    "major" {
        $major++
        $minor = 0
        $patch = 0
        $build++
    }

    "minor" {
        $minor++
        $patch = 0
        $build++
    }

    "patch" {
        $patch++
        $build++
    }

    "build" {
        $build++
    }

    default {
        throw "Mode must be: major, minor, patch, build"
    }
}

$newVersion = "$major.$minor.$patch"

# ---- WRITE VERSION ----
$content = $content -replace 'Version\s*=\s*["'']\d+\.\d+\.\d+["'']', "Version = `"$newVersion`""

# ---- WRITE BUILD ----
if ($content -match 'BuildVersion') {
    $content = $content -replace 'BuildVersion\s*=\s*["'']?\d+["'']?', "BuildVersion = `"$build`""
} else {
    # optional fallback
    $content = $content -replace 'Version\s*=\s*".*?"', "Version = `"$newVersion`",`n  BuildVersion = `"$build`""
}

Set-Content $File $content

Write-Host "Updated:"
Write-Host "  Version: $newVersion"
Write-Host "  Build:   $build"