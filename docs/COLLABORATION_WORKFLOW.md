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
| 私密、低風險、短草稿／分類 | Local Qwen | 資料不離開電腦；實題顯示不可承擔安全判斷 |
| 低風險短草稿、格式整理、獨立檢查 | Copilot Free | 保留 Codex 額度；wrapper 禁止 shell／write |
| 公開或已去敏感的低風險分析 | OpenRouter Free | 實題速度佳；允許供應、品質與 CLI 狀態文字波動 |
| 公開或已去敏感的單回合 review | Grok Build 免費試用 | 實題格式與內容完整；免費 entitlement 可能調整 |
| 架構比較、重大風險、第二意見 | Antigravity | 適合深度分析與審查 |
| 實質工作的決策檢查點、重大實作完成後、研究／安全／隱私／量測宣稱交付前 | Codex + Antigravity 監督審查 | Antigravity 獨立找問題，Codex 依證據處理並保留分歧 |
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

### 統一自動入口（預設）

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\invoke-ai.ps1 -Prompt "<PROMPT>" -TaskType Review -Sensitivity Public
```

- Codex 指定任務類型與敏感度，不要求使用者選 provider。
- 公開任務會依路由表自動降級；私人任務只允許 Local Qwen，失敗時停止，不轉送雲端。
- `-PassThru` 以 JSON 回傳實際 provider、延遲與答案，供 Codex 驗證。
- 個別 `ask-*.ps1` 保留作底層 adapter 與診斷入口，不作為日常使用介面。

### Copilot Free

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-copilot.ps1 -Prompt "<PROMPT>"
```

- 使用 GitHub Copilot CLI。
- 關閉 repository custom instructions。
- CLI 雖要求允許工具，但 wrapper 明確 deny `shell` 與 `write`。
- 支援 `-PromptBase64`，用於 Orca terminal 傳送中文或長 brief。

### Local Qwen／Ollama

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-local-qwen.ps1 -Prompt "<PROMPT>"
```

- 只呼叫 `127.0.0.1` 的 Ollama API，資料不送到雲端。
- 固定使用 `qwen3.5:4b`、8K context、temperature 0、thinking 關閉。
- wrapper 不提供 shell、檔案或網路工具，適合短草稿、分類、摘要與獨立檢查。
- 本機模型品質低於大型雲端模型時，Codex 必須拒絕低品質結果並改走其他路由。
- 不得用於安全審查、破壞性操作判斷或無人驗證的最終答案。

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

### 監督與討論流程

Antigravity 不持續旁聽，也不逐步干預 Codex。實質工作到達下列檢查點時才啟動監督：

1. 高影響方案即將定案。
2. 重大實作完成，準備進入交付或合併。
3. 研究方法、量測有效性、安全或隱私宣稱準備對外使用。

Codex 提供中立的最小 brief、必要 diff／測試／證據與通過條件。Antigravity 回報具體問題、證據缺口與風險，不修改檔案。

若發現重大問題，Codex 必須自行核對程式、測試、需求與證據，並採取以下其中一項：

- 接受問題並修正；
- 提出具體反證，使用第二次聚焦呼叫請 Antigravity 複核；
- 保留為未解風險，明確交由使用者決定。

每個使用者請求通常一次、最多兩次 Antigravity 呼叫。結果標記為「已接受問題」、「已解決分歧」或「未解風險」。最終決策、修改與交付責任仍由 Codex 承擔。

「實質工作」包含架構、跨模組介面、持久或實驗資料、外部行為、部署、安全或隱私邊界、研究方法、量測邏輯及對外宣稱的變更。純排版、錯字、註解及不改變行為的局部機械重構通常豁免。

監督 brief 至少包含：目標、限制、異動檔案或提案範圍、必要 diff／證據、測試結果、已知限制及明確通過條件。Antigravity 的輸出使用以下分級與狀態：

- `Blocker`：會造成錯誤、安全／隱私違規、資料或研究結論不可信；必須阻擋交付。
- `Warning`：具體且合理的風險或證據缺口；必須修正、反證或明確交由使用者接受。
- `Notice`：不影響正確性的改善建議。
- `STATUS: APPROVED`：沒有未處理的 Blocker／Warning。
- `STATUS: REJECTED`：存在已確認的 Blocker／Warning。
- `STATUS: NEEDS_MORE_EVIDENCE`：現有資料不足以判定。

針對重大問題的修正必須增加新的聚焦測試、檢查或證據，不可只重複原本驗證。若第二次也是最後一次允許的審查仍有 Blocker，停止合併或交付相關宣稱並交由使用者決定，不以增加第三次呼叫繞過上限。

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

環境健康檢查：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\test-ai-workers.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\test-ai-workers.ps1 -Live
```

第一條只檢查安裝與 wrapper，不消耗模型額度；第二條實際驗證登入、推論、退出碼與固定 marker。

## 7. GitHub 紀錄

### GitHub 權限邊界

- 當前 repository，以及使用者在要求或專案脈絡中點名的 repository，其唯讀操作具有持續授權。Codex 可直接查看 branch、commit、檔案、diff、PR、Issue、Actions、Release 與 metadata，或下載內容供檢查；也可列出使用者自己的 repository 以定位已點名專案。
- 不得以持續授權為由，自行遍歷無關的私人、組織或第三方 repository。
- 唯讀操作只允許一般 GitHub 網路請求，不得建立或改變遠端狀態。
- push、建立或修改 PR／Issue／留言／Release／tag、合併、關閉項目、修改設定、觸發 workflow 或重跑 job 前，必須取得明確授權。
- 使用者在當次要求中已明確要求上述遠端寫入動作與目標，即視為該次操作的授權，不重複詢問。未點名其他目標時，使用當前 repository 的功能分支與 PR 流程。
- 直接推送 protected／default branch 或任何 force push，必須明確點名目標 branch/ref 與操作；一般「push」不得推導出這些高風險行為。
- 下載內容只供檢查，不執行 repository hooks，也不自動遞迴初始化 submodules。Actions logs 與 artifacts 視為可能含敏感資料，不得回傳其中的憑證。
- 若執行環境本身要求 sandbox／系統級核准，Codex 仍須遵守；這不代表協作政策需要再次確認。

每次實質環境迭代依內容更新：

- `PROJECT_MEMORY.md`：持久事實、決策、未決問題、下一步。
- `VERSION_HISTORY.md`：版本目標、主要交付物、狀態。
- `ENVIRONMENT_CHANGELOG.md`：嘗試、卡關、原因、解法、測試結果。
- `README.md`：只有當新協作者需要知道的現況或入口改變時更新。

提交前與推送前各做一次隱私掃描。功能分支推送後，確認本機 HEAD、遠端分支 SHA 與 PR head SHA 一致。
