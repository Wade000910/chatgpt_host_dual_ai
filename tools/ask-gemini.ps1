[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Prompt
)

$ErrorActionPreference = "Stop"

$utf8 = [System.Text.UTF8Encoding]::new($false)
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

try {
    $geminiPath = (Get-Command gemini.cmd -ErrorAction Stop).Source
}
catch {
    $npmGemini = Join-Path $env:APPDATA "npm\gemini.cmd"

    if (Test-Path -LiteralPath $npmGemini) {
        $geminiPath = $npmGemini
    }
    else {
        Write-Error "gemini.cmd was not found."
        exit 3
    }
}

try {
    & $geminiPath -p $Prompt

    if ($null -eq $LASTEXITCODE) {
        exit 0
    }

    exit $LASTEXITCODE
}
catch {
    Write-Error ("Gemini CLI failed: " + $_.Exception.Message)
    exit 4
}
