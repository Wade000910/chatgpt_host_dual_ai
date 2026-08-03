[CmdletBinding()]
param(
    [switch]$New
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

try {
    Get-Command codex -ErrorAction Stop | Out-Null
} catch {
    Write-Error "Codex CLI was not found. Install it and run 'codex login' first."
    exit 1
}

$codexArgs = @(
    "-c", "features.memories=true",
    "-c", "memories.generate_memories=true",
    "-c", "memories.use_memories=true",
    "-c", 'tui.status_line=["model-with-reasoning","context-remaining","five-hour-limit","weekly-limit","git-branch"]'
)

if ($New) {
    & codex @codexArgs
} else {
    & codex resume --last @codexArgs
}
