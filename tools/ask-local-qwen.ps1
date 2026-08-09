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

$request = @{
    model = "qwen3.5:4b"
    system = "Follow the user's requested output format exactly. Be concise. Do not add explanations, questions, greetings, or emoji unless explicitly requested."
    prompt = $Prompt
    stream = $false
    think = $false
    keep_alive = "10m"
    options = @{
        temperature = 0
        num_ctx = 8192
    }
} | ConvertTo-Json -Depth 4

try {
    $response = Invoke-RestMethod `
        -Uri "http://127.0.0.1:11434/api/generate" `
        -Method Post `
        -ContentType "application/json" `
        -Body $request

    if ([string]::IsNullOrWhiteSpace([string]$response.response)) {
        Write-Error "The local model returned an empty response."
        exit 4
    }

    Write-Output ([string]$response.response).Trim()
    exit 0
}
catch {
    Write-Error ("Local Qwen through Ollama failed: " + $_.Exception.Message)
    exit 4
}
