# =============================================================================
# Frutiger Aero Theme Suite — One-Step Extension Installer (VS Code & AGY)
# =============================================================================
$ErrorActionPreference = "Stop"

$SourceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ExtName   = "synthcity-interactive.frutiger-aero-theme-1.0.0"

$Targets = @(
    (Join-Path $HOME ".vscode\extensions"),
    (Join-Path $HOME ".antigravity\extensions")
)

foreach ($BaseDir in $Targets) {
    if (Test-Path $BaseDir) {
        $DestDir = Join-Path $BaseDir $ExtName
        Write-Host "Installing Frutiger Aero Theme Suite to: $DestDir" -ForegroundColor Cyan
        if (Test-Path $DestDir) {
            Remove-Item -Path $DestDir -Recurse -Force
        }
        Copy-Item -Path $SourceDir -Destination $DestDir -Recurse -Force
        Write-Host "  [OK] Installed to $DestDir" -ForegroundColor Green
    }
}

Write-Host "`nDone! Press Ctrl+K Ctrl+T in VS Code / Antigravity and select:" -ForegroundColor Yellow
Write-Host "  - Frutiger Aero (Daylight Glass)" -ForegroundColor White
Write-Host "  - Frutiger Aero (Deep Aqua)" -ForegroundColor White
