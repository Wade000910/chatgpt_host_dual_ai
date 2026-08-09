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

$copilotLoader = Join-Path $env:APPDATA "npm\node_modules\@github\copilot\npm-loader.js"
$nodeExe = Join-Path $env:ProgramFiles "nodejs\node.exe"

if (-not (Test-Path -LiteralPath $copilotLoader)) {
    Write-Error "GitHub Copilot CLI loader was not found."
    exit 3
}

if (-not (Test-Path -LiteralPath $nodeExe)) {
    $resolvedNode = Get-Command node.exe -ErrorAction SilentlyContinue
    if ($null -eq $resolvedNode) {
        Write-Error "Node.js was not found."
        exit 3
    }

    $nodeExe = $resolvedNode.Source
}

try {
    & $nodeExe $copilotLoader `
        --prompt $Prompt `
        --silent `
        --no-auto-update `
        --no-custom-instructions `
        --allow-all-tools `
        --deny-tool shell `
        --deny-tool write

    if ($null -eq $LASTEXITCODE) {
        exit 0
    }

    exit $LASTEXITCODE
}
catch {
    Write-Error ("GitHub Copilot CLI failed: " + $_.Exception.Message)
    exit 4
}
