param(
    [string]$File,
    [string]$UuidExe = "uuidgen.exe"
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Resolve uuidgen.exe
$exePath = if (Test-Path $UuidExe) {
    (Resolve-Path $UuidExe).Path
}
elseif (Test-Path (Join-Path $scriptDir $UuidExe)) {
    Join-Path $scriptDir $UuidExe
}
else {
  $cmd = Get-Command $UuidExe -ErrorAction SilentlyContinue
  if ($cmd) { $cmd.Source } else { $null }
}

if (-not $exePath) {
    throw "uuidgen.exe not found"
}

$content = Get-Content $File -Raw

# ---- extract PluginInfo block ----
if ($content -notmatch 'PluginInfo\s*=\s*\{') {
    throw "PluginInfo table not found"
}

# ---- generate UUID only if needed ----
$needsUuid = $false

if ($content -match 'Id\s*=\s*["'']\s*["'']') { $needsUuid = $true }  # empty string
elseif ($content -notmatch 'Id\s*=') { $needsUuid = $true }          # missing
elseif ($content -match 'Id\s*=\s*nil') { $needsUuid = $true }       # nil

if (-not $needsUuid) {
    Write-Host "UUID already valid"
    exit 0
}

# ---- generate UUID ----
$uuid = & $exePath
$uuid = $uuid.Trim()

if (-not $uuid) {
    throw "uuidgen.exe returned empty output"
}

Write-Host "Setting UUID: $uuid"

# ---- replace existing Id OR insert it ----
if ($content -match 'Id\s*=') {

    # replace existing line (empty or nil)
    $content = $content -replace 'Id\s*=\s*["'']?.*?["'']?\s*,?', "Id = `"$uuid`","

} else {

    # insert after PluginInfo {
    $content = $content -replace 'PluginInfo\s*=\s*\{',
@"
PluginInfo = {
  Id = "$uuid",
"@
}

Set-Content $File $content