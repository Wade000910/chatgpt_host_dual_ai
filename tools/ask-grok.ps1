[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Prompt,

    [Parameter(Mandatory = $false)]
    [string]$PromptBase64
)

$ErrorActionPreference = "Stop"

$utf8 = New-Object System.Text.UTF8Encoding($false)
[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8

if (-not [string]::IsNullOrWhiteSpace($PromptBase64)) {
    try {
        $Prompt = $utf8.GetString([Convert]::FromBase64String($PromptBase64))
    }
    catch {
        Write-Error "PromptBase64 is not valid Base64-encoded UTF-8 text."
        exit 2
    }
}

if ([string]::IsNullOrWhiteSpace($Prompt)) {
    $Prompt = [Console]::In.ReadToEnd()
}

if ([string]::IsNullOrWhiteSpace($Prompt)) {
    Write-Error "No prompt was provided."
    exit 2
}

$grokExe = Join-Path $env:USERPROFILE ".grok\bin\grok.exe"

if (-not (Test-Path $grokExe)) {
    $resolved = Get-Command grok.exe -ErrorAction SilentlyContinue
    if ($null -eq $resolved) {
        Write-Error "Grok Build CLI was not found."
        exit 3
    }

    $grokExe = $resolved.Source
}

try {
    & $grokExe `
        --cwd ([System.IO.Path]::GetTempPath()) `
        --permission-mode plan `
        --no-subagents `
        --disable-web-search `
        --max-turns 1 `
        --output-format plain `
        --single $Prompt

    if ($null -eq $LASTEXITCODE) {
        exit 0
    }

    exit $LASTEXITCODE
}
catch {
    Write-Error ("Grok Build failed: " + $_.Exception.Message)
    exit 4
}
