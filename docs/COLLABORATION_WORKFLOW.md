# 多 AI 協作流程

這份 runbook 說明目前已驗證的工作流程。它描述實際能力，不把候選 provider 當成已配置資源。

## 1. 接收需求

Codex 先讀取 `PROJECT_MEMORY.md`，再確認：

- 使用者真正要的結果。
- 是否允許修改檔案或只需要分析。
- 是否含憑證、個資、未公開程式碼或其他敏感內容。
- 任務能否用一個代理完成。
- 外部代理的額外延遲與上下文成本是否值得。

## 2. 路由規則

| 條件 | 優先路由 | 原因 |
|---|---|---|
| 簡單問答、小修改 | Codex | 委派成本高於收益 |
| 低風險短草稿、格式整理、獨立檢查 | Copilot Free | 保留 Codex 額度；wrapper 禁止 shell／write |
| 公開或已去敏感的低風險分析 | OpenRouter Free | 使用免費模型池；允許供應與品質波動 |
| 低風險單回合、需要另一模型觀點 | Grok Build 免費試用 | OAuth 可用；免費 entitlement 可能調整 |
| 架構比較、重大風險、第二意見 | Antigravity | 適合深度分析與審查 |
| `雙AI：`／`雙 AI：`／`Dual AI:` | Codex + Antigravity | repository 的正式雙 AI 規則 |
| 修改、測試、隱私掃描、commit、push | Codex | 最終責任不可委派 |

## 3. 最小 brief

送給任何 worker 的內容只包含：

```text
目標：要回答或產出什麼
限制：不可做什麼、敏感資料界線
必要證據：允許讀取的片段或公開資訊
交付物：清單、草稿、比較或 review
通過條件：怎樣算完成
```

禁止傳送完整聊天、密碼、token、API key、配對碼或與任務無關的個資。

## 4. Worker 入口

### Copilot Free

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-copilot.ps1 -Prompt "<PROMPT>"
```

- 使用 GitHub Copilot CLI。
- 關閉 repository custom instructions。
- CLI 雖要求允許工具，但 wrapper 明確 deny `shell` 與 `write`。
- 支援 `-PromptBase64`，用於 Orca terminal 傳送中文或長 brief。

### OpenRouter Free

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-openrouter.ps1 -Prompt "<SANITIZED_PROMPT>"
```

- 使用 OpenCode 的 `openrouter/free` 路由。
- 使用 `plan` agent，並在系統暫存目錄執行。
- 只允許公開或已去敏感內容。
- 免費模型供應、速度與品質可能變動。

### Antigravity

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-antigravity.ps1 -Prompt "<PROMPT>"
```

- 用於高價值分析或正式雙 AI 流程。
- 不允許直接修改 repository。
- 一般每個使用者請求最多一次；重大未解分歧才允許第二次。

### Grok Build

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-grok.ps1 -Prompt "<PROMPT>"
```

- 使用 xAI 官方 OAuth，不使用 API key 或 API billing。
- wrapper 固定使用 plan permission mode、停用 subagents 與 web search，並限制最多一回合。
- 在系統暫存目錄執行，支援 `-PromptBase64`。
- 官方標示 available to try for free，但沒有保證永久額度；路由時視為實驗性免費資源。

## 5. Orca terminal worker

Orca 可建立可見 terminal worker。Windows 含空白、中文或長 prompt 應先轉成 UTF-8 Base64，再使用 wrapper 的 `-PromptBase64`。

可見 terminal 在命令完成後會回到 PowerShell prompt，不一定退出；完成監看流程是：

1. 建立 terminal 並保存 handle。
2. 等待 `tui-idle`。
3. 使用 `terminal read` 或 `terminal show` 輪詢預期完成標記。
4. Codex 驗證輸出。
5. 關閉測試 terminal，避免 UI 堆積。

`tui-idle` 可能早於模型輸出觸發，不能單獨視為完成證據。

## 6. Codex 最終驗證

Codex 必須自行確認：

- worker 是否真的成功執行。
- 結論是否有證據，是否遺漏限制。
- Git diff 是否只包含預期變更。
- 測試是否足以涵蓋風險。
- changed／staged files 是否含敏感資訊。
- 最終答案是否保留未解分歧，而非製造假共識。

## 7. GitHub 紀錄

每次實質環境迭代依內容更新：

- `PROJECT_MEMORY.md`：持久事實、決策、未決問題、下一步。
- `VERSION_HISTORY.md`：版本目標、主要交付物、狀態。
- `ENVIRONMENT_CHANGELOG.md`：嘗試、卡關、原因、解法、測試結果。
- `README.md`：只有當新協作者需要知道的現況或入口改變時更新。

提交前與推送前各做一次隱私掃描。功能分支推送後，確認本機 HEAD、遠端分支 SHA 與 PR head SHA 一致。
