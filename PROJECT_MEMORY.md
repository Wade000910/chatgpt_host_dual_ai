# FCO Project Memory

Last updated: 2026-08-03

## Purpose

This file preserves durable project context between Codex CLI sessions. It contains concise outcomes, not full chat transcripts.

## Confirmed facts

- FCO involves video analysis.
- The first implementation path under consideration is either a Python offline video-analysis prototype or an Android real-time version.
- The user wants Codex to host discussions and use Antigravity only when a message begins with a configured dual-AI trigger.
- Git for Windows 2.55.0 and GitHub CLI 2.94.0 were installed on 2026-08-03.
- GitHub CLI is authorized as `Wade000910`.
- The private remote repository is `https://github.com/Wade000910/chatgpt_host_dual_ai`.

## Decisions

- Current recommendation: begin with a Python offline analysis prototype, plus a very small Android device-performance probe if real-time operation may be essential.
- Reconsider direct Android-first development only if live feedback is confirmed to be indispensable to FCO's user value, or if hard privacy, offline-operation, or deployment constraints require on-device processing.
- Use feature branches and Pull Requests for GitHub delivery instead of pushing unreviewed work directly to `main`.

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
