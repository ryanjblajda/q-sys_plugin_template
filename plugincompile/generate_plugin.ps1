param(
    [string]$Entry,
    [string]$Output
)

$baseDirs = @(
    (Join-Path $PSScriptRoot "..\plugin_parts"),
    (Join-Path $PSScriptRoot "..\modules"),
    (Join-Path $PSScriptRoot "..\children")
)

$seen = @{}

function Resolve-ModulePath($name) {
    foreach ($dir in $baseDirs) {

        $candidates = @(
            (Join-Path $dir "$name.lua"),
            (Join-Path $dir "$name\init.lua")
        )

        foreach ($c in $candidates) {
            if (Test-Path $c) {
                return $c
            }
        }
    }
    return $null
}

function Inline($filePath) {

    if ($seen[$filePath]) { return "" }
    $seen[$filePath] = $true

    $text = Get-Content $filePath -Raw

    # find requires
    $pattern = 'require\s*\(\s*["''](.+?)["'']\s*\)'

    while ($text -match $pattern) {

        $mod = $matches[1]
        $modPath = Resolve-ModulePath $mod

        if (-not $modPath) {
            throw "Could not resolve module: $mod"
        }

        $replacement = Inline $modPath

        $text = $text -replace "require\(\s*['""]$mod['""]\s*\)", $replacement
    }

    return $text
}

$result = Inline $Entry

Set-Content $Output $result

Write-Host "Built $Output"