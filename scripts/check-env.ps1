#Requires -Version 5.1
<#
Checks the local toolchain for the Taylor-agent repository.
Exit code 0 when every required tool is present, 1 otherwise.
#>

$ErrorActionPreference = "Continue"
$missing = New-Object System.Collections.Generic.List[string]
$optionalMissing = New-Object System.Collections.Generic.List[string]

function Show-Tool {
    param(
        [string]$Name,
        [string]$Command,
        [string[]]$VersionArgs = @("--version"),
        [bool]$Required = $true
    )

    $cmd = Get-Command $Command -ErrorAction SilentlyContinue
    if (-not $cmd) {
        if ($Required) { $missing.Add($Name) } else { $optionalMissing.Add($Name) }
        Write-Host ("[MISS] {0,-10} {1}" -f $Name, "not found") -ForegroundColor Red
        return
    }

    try {
        $version = (& $cmd.Source @VersionArgs 2>&1 | Select-Object -First 1)
    } catch {
        $version = "(version check failed)"
    }
    Write-Host ("[ OK ] {0,-10} {1}" -f $Name, $version) -ForegroundColor Green
}

Write-Host "Taylor-agent environment check" -ForegroundColor Cyan
Write-Host ("PowerShell {0}" -f $PSVersionTable.PSVersion)
Write-Host ""

Show-Tool -Name "git"  -Command "git"  -VersionArgs @("--version")
Show-Tool -Name "node" -Command "node" -VersionArgs @("--version")
Show-Tool -Name "pnpm" -Command "pnpm" -VersionArgs @("--version")
Show-Tool -Name "dsh"  -Command "dsh"  -VersionArgs @("--version")
Show-Tool -Name "gh"   -Command "gh"   -VersionArgs @("--version") -Required $false

Write-Host ""
$sshConfig = Join-Path $HOME ".ssh\config"
if (Test-Path $sshConfig) {
    $hasGithub = Select-String -Path $sshConfig -Pattern "Host\s+github\.com" -Quiet
    if ($hasGithub) {
        Write-Host "[ OK ] ssh config has a github.com host block" -ForegroundColor Green
    } else {
        Write-Host "[WARN] ssh config exists but has no github.com host block" -ForegroundColor Yellow
    }
} else {
    Write-Host "[WARN] no ~/.ssh/config; see docs/setup.md for SSH over 443" -ForegroundColor Yellow
}

Write-Host ""
if ($missing.Count -gt 0) {
    Write-Host ("Missing required tools: {0}" -f ($missing -join ", ")) -ForegroundColor Red
    exit 1
}

if ($optionalMissing.Count -gt 0) {
    Write-Host ("Optional tools missing: {0}" -f ($optionalMissing -join ", ")) -ForegroundColor Yellow
}

Write-Host "Required toolchain is present." -ForegroundColor Green
exit 0
