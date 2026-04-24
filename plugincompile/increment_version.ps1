param(
    [string]$File,
    [string]$Mode = "patch"
)

$content = Get-Content $File -Raw

# ---- VERSION ----
if ($content -notmatch 'Version\s*=\s*["''](\d+)\.(\d+)\.(\d+)["'']') {
    throw "No Version found in $File"
}

$major = [int]$matches[1]
$minor = [int]$matches[2]
$patch = [int]$matches[3]

# ---- BUILD VERSION (always integer string) ----
if ($content -match 'BuildVersion\s*=\s*["''](\d+)["'']') {
    $buildVersion = [int]$matches[1]
} else {
    $buildVersion = 0
}

# ---- semantic versioning ----
switch ($Mode) {
    "major" {
        $major++
        $minor = 0
        $patch = 0
    }

    "minor" {
        $minor++
        $patch = 0
    }

    "patch" {
        $patch++
    }

    "build" {
        # no version change
    }
}

# ---- ALWAYS increment BuildVersion ----
$buildVersion++

$newVersion = "$major.$minor.$patch"

Write-Host "Version: $newVersion | BuildVersion: $buildVersion"

# ---- replace Version ----
$content = [regex]::Replace(
    $content,
    'Version\s*=\s*["'']\d+\.\d+\.\d+["'']',
    "Version = `"$newVersion`""
)

# ---- replace BuildVersion ----
if ($content -match 'BuildVersion\s*=') {

    $content = [regex]::Replace(
        $content,
        'BuildVersion\s*=\s*["'']?\d+["'']?',
        "BuildVersion = `"$buildVersion`""
    )

} else {

    $content = $content -replace
        '(Version\s*=\s*["'']\d+\.\d+\.\d+["''],?)',
        "`$1`n  BuildVersion = `"$buildVersion`","
}

Set-Content -Path $File -Value $content -NoNewline