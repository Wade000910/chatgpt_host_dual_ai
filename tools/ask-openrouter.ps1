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

$openCodeExe = Join-Path $env:APPDATA "npm\node_modules\opencode-ai\bin\opencode.exe"

if (-not (Test-Path -LiteralPath $openCodeExe)) {
    Write-Error "OpenCode executable was not found."
    exit 3
}

try {
    & $openCodeExe run $Prompt `
        --model openrouter/openrouter/free `
        --agent plan `
        --dir ([System.IO.Path]::GetTempPath())

    if ($null -eq $LASTEXITCODE) {
        exit 0
    }

    exit $LASTEXITCODE
}
catch {
    Write-Error ("OpenRouter through OpenCode failed: " + $_.Exception.Message)
    exit 4
}
