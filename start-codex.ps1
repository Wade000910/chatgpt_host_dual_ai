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

$memoryArgs = @(
    "-c", "features.memories=true",
    "-c", "memories.generate_memories=true",
    "-c", "memories.use_memories=true"
)

if ($New) {
    & codex @memoryArgs
} else {
    & codex resume --last @memoryArgs
}
