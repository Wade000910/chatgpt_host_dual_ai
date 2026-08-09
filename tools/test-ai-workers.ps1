[CmdletBinding()]
param([switch]$Live)

$ErrorActionPreference = "Stop"
$utf8 = New-Object System.Text.UTF8Encoding($false)
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8

$checks = @(
    @{ provider = "LocalQwen"; dependency = (Join-Path $env:LOCALAPPDATA "Programs\Ollama\ollama.exe"); wrapper = "ask-local-qwen.ps1" },
    @{ provider = "OpenRouter"; dependency = (Join-Path $env:APPDATA "npm\node_modules\opencode-ai\bin\opencode.exe"); wrapper = "ask-openrouter.ps1" },
    @{ provider = "Grok"; dependency = (Join-Path $env:USERPROFILE ".grok\bin\grok.exe"); wrapper = "ask-grok.ps1" },
    @{ provider = "Copilot"; dependency = (Join-Path $env:APPDATA "npm\node_modules\@github\copilot\npm-loader.js"); wrapper = "ask-copilot.ps1" },
    @{ provider = "Antigravity"; dependency = (Join-Path $env:LOCALAPPDATA "agy\bin\agy.exe"); wrapper = "ask-antigravity.ps1" }
)

$powerShellExe = Join-Path $PSHOME "powershell.exe"
$results = foreach ($check in $checks) {
    $wrapperPath = Join-Path $PSScriptRoot $check.wrapper
    $installed = (Test-Path -LiteralPath $check.dependency) -and (Test-Path -LiteralPath $wrapperPath)
    $liveOk = $null
    $elapsed = $null

    if ($Live -and $installed) {
        $marker = "HEALTH_" + $check.provider.ToUpperInvariant() + "_OK"
        $prompt = "Reply with exactly $marker and nothing else."
        $encoded = [Convert]::ToBase64String($utf8.GetBytes($prompt))
        $timer = [Diagnostics.Stopwatch]::StartNew()
        $previousErrorAction = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        $output = & $powerShellExe -NoProfile -ExecutionPolicy Bypass -File $wrapperPath -PromptBase64 $encoded 2>&1
        $exitCode = $LASTEXITCODE
        $ErrorActionPreference = $previousErrorAction
        $timer.Stop()
        $text = (($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine)
        $liveOk = $exitCode -eq 0 -and $text -match [regex]::Escape($marker)
        $elapsed = $timer.ElapsedMilliseconds
    }

    [pscustomobject]@{
        provider = $check.provider
        installed = $installed
        liveTested = [bool]$Live
        healthy = if ($Live) { [bool]$liveOk } else { $installed }
        elapsedMs = $elapsed
    }
}

$results | ConvertTo-Json -Depth 3
if ($results.healthy -contains $false) { exit 1 }
exit 0
