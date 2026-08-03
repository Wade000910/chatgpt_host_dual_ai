# FCO Project Memory

Last updated: 2026-08-03

## Purpose

This file preserves durable project context between Codex CLI sessions. It contains concise outcomes, not full chat transcripts.

## Confirmed facts

- FCO involves video analysis.
- The first implementation path under consideration is either a Python offline video-analysis prototype or an Android real-time version.
- The user wants Codex to remain the primary host and final verifier, with Antigravity required for configured dual-AI triggers and available for automatic high-value delegation on substantial tasks.
- Git for Windows 2.55.0 and GitHub CLI 2.94.0 were installed on 2026-08-03.
- GitHub CLI is authorized as `Wade000910`.
- The public remote repository is `https://github.com/Wade000910/chatgpt_host_dual_ai`.

## Decisions

- Current recommendation: begin with a Python offline analysis prototype, plus a very small Android device-performance probe if real-time operation may be essential.
- Reconsider direct Android-first development only if live feedback is confirmed to be indispensable to FCO's user value, or if hard privacy, offline-operation, or deployment constraints require on-device processing.
- Use feature branches and Pull Requests for GitHub delivery instead of pushing unreviewed work directly to `main`.
- Keep a collaborator-facing project overview in `README.md` so others with repository access can understand the configured dual-AI, memory, GitHub, and safety workflows without exposing credentials.
- Treat every tracked file and commit as publicly visible; exclude credentials and unnecessary personal information before pushing.
- Use Codex as the primary controller and final editor/verifier. Codex may automatically delegate substantial independent analysis, drafting, test strategy, or review work to Antigravity CLI, normally once and never more than twice per user request.
- Show Codex model, remaining context, five-hour usage, weekly usage, and Git branch in the CLI footer. Antigravity CLI does not currently expose a reliable quota value for the Codex footer.
- The installed standalone Gemini CLI 0.46.0 reports that Gemini Code Assist for individuals no longer supports this client and directs users to Antigravity, so it is not used as the active auxiliary workflow.

## Reasons

- Python provides a faster loop for validating analysis quality and user value.
- A full Android version introduces camera, model-conversion, device-compatibility, latency, battery, and thermal risks before the core analysis has been validated.

## Open questions

- Is FCO's target experience a post-recording report or live feedback while recording?
- What accuracy, latency, and frame-rate thresholds are acceptable?
- Which Android device classes must be supported?
- Must video remain entirely on the device?
- What are the team's Python/ML and Android/on-device deployment capabilities?

## Next action

- Define a one-week Python baseline experiment using 10-20 representative videos and explicit success thresholds before committing to the Android architecture.

## Memory rules

- Store confirmed facts, decisions, rationale, open questions, and next actions only.
- Do not store secrets, credentials, unnecessary personal data, or private reasoning.
- The user's latest explicit instruction overrides this file.
