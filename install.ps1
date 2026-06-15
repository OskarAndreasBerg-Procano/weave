# weave installer for Windows PowerShell.
# usage:  irm https://raw.githubusercontent.com/OskarAndreasBerg-Procano/weave/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$RepoUrl    = "https://raw.githubusercontent.com/OskarAndreasBerg-Procano/weave/main/weave"
$InstallDir = if ($env:WEAVE_INSTALL_DIR) { $env:WEAVE_INSTALL_DIR } else { "$env:USERPROFILE\bin" }
$Dest       = Join-Path $InstallDir "weave"

function Step($m) { Write-Host "-> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "+  $m" -ForegroundColor Green }
function Warn($m) { Write-Host "!  $m" -ForegroundColor Yellow }
function Die($m)  { Write-Host "x  $m" -ForegroundColor Red; exit 1 }

# 1. tools
$PY = $null
foreach ($c in @("python", "python3")) {
  if (Get-Command $c -ErrorAction SilentlyContinue) { $PY = $c; break }
}
if (-not $PY) {
  Die "Python 3 not found on PATH. Install from https://python.org first (tick 'Add Python to PATH')."
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Warn "'claude' CLI not on PATH yet. Install Claude Code from https://claude.com/code first, then re-run this installer."
  exit 1
}

# 2. download
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Step "downloading weave -> $Dest"
Invoke-WebRequest -Uri $RepoUrl -OutFile $Dest -UseBasicParsing
Ok "installed $Dest"

# 3. PATH (user scope)
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$alreadyOnPath = ($userPath -split ";") -contains $InstallDir
if (-not $alreadyOnPath) {
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$InstallDir", "User")
  $env:Path = "$env:Path;$InstallDir"
  Ok "added $InstallDir to user PATH (open a new terminal to pick it up)"
}

# 4. register globally
Step "registering weave with Claude Code (user scope)"
& $PY $Dest install

Write-Host ""
Write-Host "  weave is installed."
Write-Host ""
Write-Host "  Next:"
Write-Host "    cd <any project>"
Write-Host "    $PY `"$Dest`" init       # creates .weave/graph.json + a CLAUDE.md block"
Write-Host "    claude                   # open Claude Code - weave_* tools are live"
Write-Host ""
Write-Host "  Optional:"
Write-Host "    $PY `"$Dest`" serve      # opens the live workspace at 127.0.0.1:4747"
Write-Host ""
