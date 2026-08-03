[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Prompt
)

$ErrorActionPreference = "Stop"

$utf8 = New-Object System.Text.UTF8Encoding($false)
[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8

if ([string]::IsNullOrWhiteSpace($Prompt)) {
    $Prompt = [Console]::In.ReadToEnd()
}

if ([string]::IsNullOrWhiteSpace($Prompt)) {
    Write-Error "No prompt was provided."
    exit 2
}

$agyExe = Join-Path $env:LOCALAPPDATA "agy\bin\agy.exe"

if (-not (Test-Path $agyExe)) {
    Write-Error "Antigravity CLI was not found."
    exit 3
}

try {
    & $agyExe -p $Prompt --output-format text

    if ($null -eq $LASTEXITCODE) {
        exit 0
    }

    exit $LASTEXITCODE
}
catch {
    Write-Error ("Antigravity CLI failed: " + $_.Exception.Message)
    exit 4
}
