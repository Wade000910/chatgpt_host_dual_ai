[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Prompt,

    [Parameter(Mandatory = $false)]
    [string]$PromptBase64,

    [ValidateSet("Auto", "Draft", "Review", "Architecture", "Classification")]
    [string]$TaskType = "Auto",

    [ValidateSet("Public", "Private")]
    [string]$Sensitivity = "Public",

    [ValidateSet("Auto", "LocalQwen", "OpenRouter", "Grok", "Copilot", "Antigravity")]
    [string]$Provider = "Auto",

    [switch]$PassThru
)

$ErrorActionPreference = "Stop"
$utf8 = New-Object System.Text.UTF8Encoding($false)
[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8

if (-not [string]::IsNullOrWhiteSpace($PromptBase64)) {
    try { $Prompt = $utf8.GetString([Convert]::FromBase64String($PromptBase64)) }
    catch { Write-Error "PromptBase64 is not valid Base64-encoded UTF-8 text."; exit 2 }
}
if ([string]::IsNullOrWhiteSpace($Prompt)) { $Prompt = [Console]::In.ReadToEnd() }
if ([string]::IsNullOrWhiteSpace($Prompt)) { Write-Error "No prompt was provided."; exit 2 }

$routes = @{
    LocalQwen = "ask-local-qwen.ps1"
    OpenRouter = "ask-openrouter.ps1"
    Grok = "ask-grok.ps1"
    Copilot = "ask-copilot.ps1"
    Antigravity = "ask-antigravity.ps1"
}

if ($Provider -ne "Auto") {
    $candidates = @($Provider)
}
elseif ($Sensitivity -eq "Private") {
    # Never leak a private prompt to a cloud fallback.
    $candidates = @("LocalQwen")
}
else {
    switch ($TaskType) {
        "Review" { $candidates = @("Grok", "Copilot", "Antigravity", "OpenRouter") }
        "Architecture" { $candidates = @("Antigravity", "Grok", "Copilot") }
        "Draft" { $candidates = @("OpenRouter", "Grok", "Copilot") }
        "Classification" { $candidates = @("OpenRouter", "LocalQwen", "Grok") }
        default { $candidates = @("OpenRouter", "Grok", "Copilot") }
    }
}

$encoded = [Convert]::ToBase64String($utf8.GetBytes($Prompt))
$powerShellExe = Join-Path $PSHOME "powershell.exe"
$failures = New-Object System.Collections.Generic.List[string]

foreach ($candidate in $candidates) {
    $scriptPath = Join-Path $PSScriptRoot $routes[$candidate]
    if (-not (Test-Path -LiteralPath $scriptPath)) {
        $failures.Add("${candidate}: wrapper missing")
        continue
    }

    $timer = [Diagnostics.Stopwatch]::StartNew()
    $previousErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $output = & $powerShellExe -NoProfile -ExecutionPolicy Bypass -File $scriptPath -PromptBase64 $encoded 2>&1
    $exitCode = $LASTEXITCODE
    $ErrorActionPreference = $previousErrorAction
    $timer.Stop()
    $answer = (($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine).Trim()

    if ($exitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($answer)) {
        if ($PassThru) {
            [pscustomobject]@{
                provider = $candidate
                taskType = $TaskType
                sensitivity = $Sensitivity
                elapsedMs = $timer.ElapsedMilliseconds
                answer = $answer
            } | ConvertTo-Json -Depth 3
        }
        else { Write-Output $answer }
        exit 0
    }

    $failures.Add("${candidate}: exit $exitCode")
}

Write-Error ("No eligible AI worker succeeded. " + ($failures -join "; "))
exit 4
