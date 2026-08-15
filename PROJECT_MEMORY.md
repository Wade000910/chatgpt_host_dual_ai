# FCO Project Memory

Last updated: 2026-08-15

## Purpose

This file preserves durable project context between Codex CLI sessions. It contains concise outcomes, not full chat transcripts.

## Confirmed facts

- FCO involves video analysis.
- The first implementation path under consideration is either a Python offline video-analysis prototype or an Android real-time version.
- The user wants Codex to remain the primary host and final verifier, with Antigravity required for configured dual-AI triggers and available for automatic high-value delegation on substantial tasks.
- Git for Windows 2.55.0 and GitHub CLI 2.94.0 were installed on 2026-08-03.
- GitHub CLI is authorized as `Wade000910`.
- The public remote repository is `https://github.com/Wade000910/chatgpt_host_dual_ai`.
- The environment uses selected skills from `mattpocock/skills`; `grill-me` and `grilling` are currently visible in both the standalone Codex and Orca runtimes.
- The host currently runs Windows Home, cannot act as a supported Microsoft RDP host, and had no detected Tailscale, RustDesk, AnyDesk, or TeamViewer installation during the 2026-08-08 audit.
- Chrome Remote Desktop Host 151.0.7922.13 was installed and verified on 2026-08-08; the `chromoting` service is running with automatic startup.
- Orca Mobile pairing with the user's iPhone was confirmed successful on 2026-08-08 by continuing the active Orca session from the phone.
- Orca Relay was verified over the iPhone's 4G/5G connection: prompts, completion notifications, and response content arrive successfully. Mobile text rendering has a small delay that is currently acceptable to the user.
- The next environment goal is efficient multi-AI collaboration with minimal token waste. As of 2026-08-08, Codex, paid Antigravity, and GitHub Copilot Free are callable; Copilot is available through an Orca terminal-worker wrapper, while automatic provider routing remains future work.
- Correction: the user has a paid Antigravity account. Antigravity CLI is installed, authenticated, callable through the wrapper, detected on `PATH`, and enabled in Orca's Agents settings. Orca's usage panel incorrectly reports it as unavailable because legacy Gemini OAuth tracking is disabled; this does not prevent Antigravity execution.
- GitHub Copilot Free is active for the user's GitHub account. GitHub Copilot CLI 1.0.78 is installed and authenticated; a minimal no-file-access prompt returned `COPILOT_OK`, and the Git worktree remained clean.
- `tools/ask-copilot.ps1` is the repository's read-only Copilot worker entry point. It accepts plain or Base64-encoded UTF-8 prompts, disables project instructions, denies shell and write tools, and is designed for Orca terminal workers or direct one-shot delegation.
- Orca successfully created a visible Copilot terminal worker and read back both `ORCA_COPILOT_WORKER_OK` and a Base64-delivered UTF-8 test result, `BASE64_WORKER_OK`. Visible worker terminals return to a shell prompt, so completion monitoring must read an expected marker instead of waiting for process exit.
- A first tiny read-only comparison asked Copilot Free and Antigravity to compress the same three routing constraints into one Traditional Chinese sentence. Both preserved all constraints; Copilot took about 12.9 seconds and Antigravity about 10.5 seconds. This single sample verifies both paths but is not enough to rank providers.
- OpenCode 1.18.15 is installed and authenticated to OpenRouter using a locally stored API key. The `openrouter/free` route returned `OPENROUTER_FREE_OK` in about 5.4 seconds through OpenCode's plan agent, with no project changes.
- `tools/ask-openrouter.ps1` is the read-only OpenRouter worker entry point. It supports plain or Base64 UTF-8 prompts, forces `openrouter/free`, uses OpenCode's plan agent, and runs from the system temporary directory.
- Environment v0.4 reorganizes collaborator-facing documentation into `README.md`, `docs/COLLABORATION_WORKFLOW.md`, `VERSION_HISTORY.md`, and `ENVIRONMENT_CHANGELOG.md`; each future environment version must update the version history and implementation changelog.
- Grok Build 1.0.0 is installed and authenticated through xAI OAuth without an API key or API billing. A restricted headless test returned `GROK_FREE_OK` in about 6.5 seconds with no project changes. The official product says available to try for free but does not guarantee permanent quota.
- `tools/ask-grok.ps1` is the experimental Grok worker entry point. It supports plain or Base64 UTF-8 prompts, uses plan permission mode from the system temporary directory, disables subagents and web search, and limits execution to one turn.
- Local hardware provides an NVIDIA laptop GPU with 8GB VRAM and 16GB system RAM. Ollama 0.32.6 and `qwen3.5:4b` are installed; the model runs with 100% GPU offload. With thinking disabled and 8K context, a fixed-response test completed in about 2.4 seconds at about 65 tokens per second.
- `tools/ask-local-qwen.ps1` is the private local worker entry point. It calls only the localhost Ollama API, fixes temperature to zero, disables thinking, limits context to 8K, and exposes no file, shell, or network tools.
- The local wrapper initially failed an exact-format Chinese prompt; adding a strict fixed system instruction corrected it, producing `LOCAL_WRAPPER_OK` in about 3.3 seconds. This confirms the wrapper path while preserving the rule that Codex must validate small-model output quality.
- A shared PowerShell security-review benchmark found all three requested risks through Grok (about 14.6 seconds), Antigravity (about 17.2 seconds), Copilot (about 37.0 seconds), and OpenRouter (about 11.4 seconds). Local Qwen was faster but failed formatting and misunderstood the code, so it is not approved for security review.
- Copilot and OpenRouter wrappers now call their underlying Node loader or native executable directly. This prevents npm `.cmd` shims from reinterpreting prompt metacharacters such as `|`.
- Environment v0.8 provides `tools/invoke-ai.ps1` as the single default delegation entry point and `tools/test-ai-workers.ps1` for static or live health checks. Codex selects task type and sensitivity; the user does not need to choose or reconfigure providers in later sessions.
- Environment v0.9 adds checkpoint-based Antigravity supervision for substantive work. It reviews high-impact plans, major implementations, and research, safety, privacy, or measurement claims; Codex verifies issues, may use one focused follow-up, and records unresolved risk without manufacturing consensus.
- The user grants standing authorization for read-only GitHub access to the active repository and repositories named or placed in scope by the user. Codex should not ask before inspecting them or listing the user's repositories to locate a named project, but must not autonomously traverse unrelated private or organization repositories. Explicit authorization is required before sending local or newly generated content to GitHub or changing remote state; an instruction that names the action and target is sufficient for that request. Feature branches and PRs remain the default, while direct protected/default-branch pushes and force pushes require explicit target-specific authorization.
- All five live health checks passed. Unified routing selected Local Qwen for a private classification smoke test and Grok for a public review smoke test. Private prompts are never allowed to fall back to cloud workers.

## Decisions

- Current priority is migrating the working environment from standalone Codex CLI into Orca. FCO implementation and the dual-AI collaboration workflow are deferred until that migration is understood and stabilized.
- After the Orca migration is stable, the next environment objective is secure phone control of Orca agent sessions through the official Orca Mobile companion.
- Orca Mobile is the selected primary phone-access path. Chrome Remote Desktop remains an optional full-Windows fallback; AC-powered automatic sleep is disabled to preserve Orca host availability, while battery sleep remains set to three minutes.
- Multi-AI policy: Codex remains the sole coordinator and verifier; use one agent by default, and use Antigravity as a checkpoint-based supervisory reviewer for substantive high-impact work while keeping it read-only.
- Proposed quota policy: route suitable low-risk work to verified free-tier agents first, then give Codex only compressed candidate results, diffs, and evidence for final decisions. Preserve Codex quota as the scarce fallback and verification resource.
- Proposed context policy: never pass raw transcripts between agents; use a compact brief containing objective, constraints, target files or evidence, deliverable, and pass/fail criteria.
- Current recommendation: begin with a Python offline analysis prototype, plus a very small Android device-performance probe if real-time operation may be essential.
- Reconsider direct Android-first development only if live feedback is confirmed to be indispensable to FCO's user value, or if hard privacy, offline-operation, or deployment constraints require on-device processing.
- Use feature branches and Pull Requests for GitHub delivery instead of pushing unreviewed work directly to `main`.
- Keep a collaborator-facing project overview in `README.md` so others with repository access can understand the configured dual-AI, memory, GitHub, and safety workflows without exposing credentials.
- Treat every tracked file and commit as publicly visible; exclude credentials and unnecessary personal information before pushing.
- Do not duplicate permission questions for read-only GitHub access. Platform-enforced sandbox prompts may still occur independently of the project policy.
- Use Codex as the primary controller and final editor/verifier. Codex may automatically delegate substantial independent analysis, drafting, test strategy, or review work to Antigravity CLI, normally once and never more than twice per user request.
- Show Codex model, remaining context, five-hour usage, weekly usage, and Git branch in the CLI footer. Antigravity CLI does not currently expose a reliable quota value for the Codex footer.
- The installed standalone Gemini CLI 0.46.0 reports that Gemini Code Assist for individuals no longer supports this client and directs users to Antigravity, so it is not used as the active auxiliary workflow.
- Use the unified router for normal delegation. Individual wrappers are adapters and diagnostic entry points; existing configured providers should not require user setup again unless authentication actually expires.
- Environment audit on 2026-08-08 found a clean `main` branch synchronized with `origin/main`; all three PowerShell scripts parse without syntax errors.
- The tracked Markdown files are valid UTF-8. Windows PowerShell 5.1's default `Get-Content` decoding can display their Chinese text as mojibake unless `-Encoding utf8` is used.
- Codex CLI 0.147.0 is available through `codex.cmd`, and Antigravity CLI 1.1.11 is present. In a normal PowerShell session, the default execution policy can block the npm `codex.ps1` shim; the documented launcher uses `-ExecutionPolicy Bypass`.

## Reasons

- Python provides a faster loop for validating analysis quality and user value.
- A full Android version introduces camera, model-conversion, device-compatibility, latency, battery, and thermal risks before the core analysis has been validated.

## Open questions

- Is FCO's target experience a post-recording report or live feedback while recording?
- What accuracy, latency, and frame-rate thresholds are acceptable?
- Which Android device classes must be supported?
- Must video remain entirely on the device?
- What are the team's Python/ML and Android/on-device deployment capabilities?
- Should the workspace add an automated health check, a repeatable privacy-scan command, and validation for the dual-AI wrapper before FCO implementation begins?
- Should the literal Markdown escape characters in `AGENTS.md` be normalized for readability and reliable parsing?
- How does the Copilot-first worker compare with Antigravity-first on completion time, quota cost, and Codex verification effort?
- Antigravity CLI is Google's successor to Gemini CLI for individual free, Google AI Pro, and Ultra accounts as of 2026-06-18; it must not be counted as a separate quota pool from Gemini CLI. Grok Build is now a verified experimental free-trial worker, but its quota is not guaranteed; Kimi Code and MiniMax are not stable free resources under their current official plans.
- Free-resource priority: Local Qwen only for private low-risk drafts or classification; OpenRouter Free for sanitized low-risk analysis; Grok Build for sanitized single-turn review; Copilot Free for stronger low-risk drafts when extra latency is acceptable. Claude Code has no standalone free CLI entitlement, and Qwen OAuth free access ended on 2026-04-15.

## Next action

- Apply the Antigravity supervisory checkpoint to the next substantive Basketball-MVP-System planning or implementation task, then record whether it found an accepted issue, resolved disagreement, or unresolved risk without storing prompts or sensitive content.

## Memory rules

- Store confirmed facts, decisions, rationale, open questions, and next actions only.
- Do not store secrets, credentials, unnecessary personal data, or private reasoning.
- The user's latest explicit instruction overrides this file.
