param(
    [string]$Entry,
    [string]$Out,
    [string]$Base = "plugin_parts"
)

$seen = @{}

function Inline($text) {
    return [regex]::Replace($text, 'require\s*\(\s*["''](.+?)["'']\s*\)', {
        param($m)

        $mod = $m.Groups[1].Value

        if ($seen.ContainsKey($mod)) {
            return "-- skipped duplicate require: $mod"
        }

        $seen[$mod] = $true

        $file = Join-Path $Base ($mod + ".lua")

        if (!(Test-Path $file)) {
            throw "Missing module: $file"
        }

        $content = Get-Content $file -Raw

        return "`n-- BEGIN $mod`n" + (Inline $content) + "`n-- END $mod`n"
    })
}

$root = Get-Content $Entry -Raw
$result = Inline $root

Set-Content $Out $result

Write-Host "Built $Out"