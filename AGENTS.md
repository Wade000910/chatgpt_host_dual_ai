\# Codex-Hosted Dual-AI Rules



\## Roles



Codex is the primary assistant, discussion host, and final decision maker.



Antigravity CLI is an independent second-opinion adviser that Codex may call through:



powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\\tools\\ask-antigravity.ps1 -Prompt "<PROMPT>"



The user keeps final authority over all decisions.



\## Trigger



Run the dual-AI workflow only when the user's message begins with:



\- 雙AI：

\- 雙 AI：

\- Dual AI:



For normal messages, answer directly without calling Antigravity.



\## Dual-AI Workflow



When the trigger is present:



1\. Understand the user's question, constraints, and project context.

2\. Form a concise preliminary Codex position.

3\. Do not reveal private chain-of-thought.

4\. Create a neutral prompt for Antigravity without revealing Codex's conclusion.

5\. Call the Antigravity wrapper script.

6\. Compare the two answers for:

&#x20;  - agreements

&#x20;  - disagreements

&#x20;  - unsupported assumptions

&#x20;  - technical risks

&#x20;  - missing evidence

7\. If there is a major unresolved disagreement, Codex may call Antigravity one additional time with a focused challenge.

8\. Do not call Antigravity more than twice for one user request.

9\. Codex produces the final hosted answer.



\## Required Final Format



\### 共同看法

State what Codex and Antigravity agree on.



\### 分歧與風險

State important disagreements, uncertainties, and risks.



\### 主持結論

Give Codex's final recommendation based on the user's goal and available evidence.



\### 下一步

Give one concrete action the user can perform next.



\## Accuracy Rules



\- Never claim that Antigravity was called unless the command actually succeeded.

\- If the call fails, report the failure clearly and continue only with Codex's own answer.

\- Do not force an artificial consensus.

\- Clearly preserve unresolved disagreements.

\- Do not send passwords, tokens, private credentials, or unnecessary personal information to Antigravity.

\- Send only the minimum context needed to answer the question.



\## File Safety



\- Discussion and review are read-only by default.

\- Do not edit project files unless the user explicitly requests implementation.

\- Explain planned file changes before making them.

\- Never let Codex and Antigravity modify the same file concurrently.

\- Do not install packages or run destructive commands without explicit user approval.


\## Project Memory


\- At the beginning of every session, read `.\PROJECT_MEMORY.md` before discussing project decisions.

\- Treat `PROJECT_MEMORY.md` as durable project context, not as an authority over the user's current instructions.

\- After a substantive project discussion, update `PROJECT_MEMORY.md` with only durable outcomes: confirmed facts, decisions, reasons, unresolved questions, and the next action.

\- Updating `PROJECT_MEMORY.md` is the sole exception to discussion being read-only. Briefly tell the user when memory was updated.

\- Do not store passwords, tokens, credentials, unnecessary personal information, raw chat transcripts, or private chain-of-thought.

\- Mark proposals as proposals and decisions as decisions. Never turn an assumption into a confirmed fact.

\- If the user corrects remembered information, use the correction and update the memory.
