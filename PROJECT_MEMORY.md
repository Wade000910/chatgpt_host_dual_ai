# FCO Project Memory

Last updated: 2026-08-08

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
- The next environment goal is efficient multi-AI collaboration with minimal token waste. As of 2026-08-08, Codex, paid Antigravity, and GitHub Copilot Free are callable; Copilot is not yet wired into Orca worker routing.
- Correction: the user has a paid Antigravity account. Antigravity CLI is installed, authenticated, callable through the wrapper, detected on `PATH`, and enabled in Orca's Agents settings. Orca's usage panel incorrectly reports it as unavailable because legacy Gemini OAuth tracking is disabled; this does not prevent Antigravity execution.
- GitHub Copilot Free is active for the user's GitHub account. GitHub Copilot CLI 1.0.78 is installed and authenticated; a minimal no-file-access prompt returned `COPILOT_OK`, and the Git worktree remained clean.

## Decisions

- Current priority is migrating the working environment from standalone Codex CLI into Orca. FCO implementation and the dual-AI collaboration workflow are deferred until that migration is understood and stabilized.
- After the Orca migration is stable, the next environment objective is secure phone control of Orca agent sessions through the official Orca Mobile companion.
- Orca Mobile is the selected primary phone-access path. Chrome Remote Desktop remains an optional full-Windows fallback; AC-powered automatic sleep is disabled to preserve Orca host availability, while battery sleep remains set to three minutes.
- Proposed multi-AI policy: Codex remains the sole coordinator and verifier; use one agent by default, Orca workers only for genuinely independent parallel tasks, and Antigravity only for high-value architecture or review, or after repeated failed attempts.
- Proposed quota policy: route suitable low-risk work to verified free-tier agents first, then give Codex only compressed candidate results, diffs, and evidence for final decisions. Preserve Codex quota as the scarce fallback and verification resource.
- Proposed context policy: never pass raw transcripts between agents; use a compact brief containing objective, constraints, target files or evidence, deliverable, and pass/fail criteria.
- Current recommendation: begin with a Python offline analysis prototype, plus a very small Android device-performance probe if real-time operation may be essential.
- Reconsider direct Android-first development only if live feedback is confirmed to be indispensable to FCO's user value, or if hard privacy, offline-operation, or deployment constraints require on-device processing.
- Use feature branches and Pull Requests for GitHub delivery instead of pushing unreviewed work directly to `main`.
- Keep a collaborator-facing project overview in `README.md` so others with repository access can understand the configured dual-AI, memory, GitHub, and safety workflows without exposing credentials.
- Treat every tracked file and commit as publicly visible; exclude credentials and unnecessary personal information before pushing.
- Use Codex as the primary controller and final editor/verifier. Codex may automatically delegate substantial independent analysis, drafting, test strategy, or review work to Antigravity CLI, normally once and never more than twice per user request.
- Show Codex model, remaining context, five-hour usage, weekly usage, and Git branch in the CLI footer. Antigravity CLI does not currently expose a reliable quota value for the Codex footer.
- The installed standalone Gemini CLI 0.46.0 reports that Gemini Code Assist for individuals no longer supports this client and directs users to Antigravity, so it is not used as the active auxiliary workflow.
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
- How should GitHub Copilot CLI be exposed as an Orca worker and measured against Antigravity before adding another provider?
- Antigravity CLI is Google's successor to Gemini CLI for individual free, Google AI Pro, and Ultra accounts as of 2026-06-18; it must not be counted as a separate quota pool from Gemini CLI. Grok remains an experiment candidate because its official free coding quota is not clearly documented; Kimi Code and MiniMax are not stable free resources under their current official plans.
- Free-resource priority: GitHub Copilot Free first; OpenRouter free models through OpenCode second for public or sanitized low-risk tasks; Grok Free as an experimental source; local models after hardware validation. Claude Code has no standalone free CLI entitlement, and Qwen OAuth free access ended on 2026-04-15.

## Next action

- Connect the verified GitHub Copilot CLI as an Orca worker, then compare one Copilot-first task with the existing Antigravity-first baseline while Codex performs only final verification.

## Memory rules

- Store confirmed facts, decisions, rationale, open questions, and next actions only.
- Do not store secrets, credentials, unnecessary personal data, or private reasoning.
- The user's latest explicit instruction overrides this file.
