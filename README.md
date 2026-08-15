# Codex 主持的 Orca 多 AI 工作區

這個公開 repository 保存一套已實際驗證的 Windows／Orca 多 AI 協作環境。Codex 負責理解需求、分配工作、修改檔案與最終驗證；其他 AI 只接收最小必要 brief，協助唯讀分析、草稿或審查。

目前版本是 **Environment v0.9**。手機連線、四個雲端輔助來源、一個完全本地的 Qwen worker、零設定自動路由，以及 Antigravity 檢查點式監督流程都已建立。

## 目前狀態

| 元件 | 狀態 | 用途 | 修改專案 |
|---|---|---|---|
| Codex | 已驗證 | 主持、決策、實作、測試、隱私掃描與最終交付 | 可以 |
| Antigravity | 已驗證，付費帳號 | 架構比較、第二意見，以及實質工作檢查點的監督審查 | 不可以 |
| GitHub Copilot Free | 已驗證 | 免費優先的低風險草稿與獨立檢查 | wrapper 禁止 shell／write |
| OpenRouter Free／OpenCode | 已驗證 | 公開或已去敏感任務的免費模型池 | 使用 plan agent 與暫存目錄 |
| Orca Mobile | 已驗證 | iPhone 經行動網路延續桌面 Orca 工作階段 | 不適用 |
| Grok Build | 已驗證，免費試用 | 一回合的低風險獨立分析 | plan mode、停用 subagents／web search |
| Local Qwen／Ollama | 已驗證，本機免費 | 私密、低風險、短回合背景任務 | 無工具、8K context、thinking 關閉 |

## 核心流程

```text
使用者需求
  ↓
Codex 判斷敏感度、風險、任務大小與是否值得委派
  ├─ 私密且低風險的短任務 → Local Qwen（第一順位）
  ├─ 低風險、短草稿／檢查 → Copilot Free
  ├─ 公開或已去敏感、可容忍供應波動 → OpenRouter Free
  ├─ 低風險單回合、需要另一模型觀點 → Grok Build 免費試用
  ├─ 架構、重大風險、正式雙 AI 觸發 → Antigravity
  └─ 修改、測試、安全檢查、最終答案 → Codex
```

預設只使用一個代理。只有工作可獨立切分且平行化確實有益時，才啟動多個 worker。代理之間不傳完整聊天紀錄，只傳：目標、限制、必要證據、交付物與通過條件。

實質工作在高影響方案定案、重大實作完成，或研究／安全／隱私／量測宣稱交付前，由 Antigravity 進行一次獨立監督審查。若發現重大問題，Codex 依證據修正或進行一次聚焦複核，並保留未解分歧；Antigravity 不修改檔案，也不取代使用者與 Codex 的最終決策。

完整路由與操作方式見 [協作流程](docs/COLLABORATION_WORKFLOW.md)。

## 快速開始

1. 閱讀 [PROJECT_MEMORY.md](PROJECT_MEMORY.md)，取得目前決策與下一步。
2. 確認目前分支與工作區狀態：

   ```powershell
   git status --short --branch
   ```

3. 從 Orca 開啟此 workspace；Orca Mobile 只負責延續桌面工作階段，桌面 Orca 必須保持執行且電腦不可睡眠。
4. Codex 預設透過單一入口自動選擇與降級；不需要使用者指定 provider：

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\invoke-ai.ps1 -Prompt "<PROMPT>" -TaskType Review -Sensitivity Public
   ```

   安裝狀態檢查使用 `tools/test-ai-workers.ps1`；只有需要實際消耗一次各 provider 額度時才加 `-Live`。

Windows PowerShell 可能阻擋 npm 的 `.ps1` shim；腳本內直接使用 Node loader 或原生 executable，避免 `.cmd` 再解析長 prompt，也不依賴修改全機 Execution Policy。

## 正式雙 AI 觸發

訊息以 `雙AI：`、`雙 AI：` 或 `Dual AI:` 開頭時，Codex 必須呼叫 Antigravity，並以「共同看法、分歧與風險、主持結論、下一步」交付。Antigravity 每個請求最多呼叫兩次，且不得修改檔案。

## 文件導航

| 文件 | 讀者應從中得到什麼 |
|---|---|
| [PROJECT_MEMORY.md](PROJECT_MEMORY.md) | 現在已確認什麼、做過哪些決策、下一步是什麼 |
| [docs/COLLABORATION_WORKFLOW.md](docs/COLLABORATION_WORKFLOW.md) | 任務如何分類、交給誰、如何回收與驗證 |
| [VERSION_HISTORY.md](VERSION_HISTORY.md) | v0.1 至目前版本各自完成了什麼 |
| [ENVIRONMENT_CHANGELOG.md](ENVIRONMENT_CHANGELOG.md) | 實作過程的卡關、原因、解法與測試證據 |
| [AGENTS.md](AGENTS.md) | Codex 在此 repository 必須遵守的執行規則 |

## Repository 檔案

| 路徑 | 用途 |
|---|---|
| `tools/ask-antigravity.ps1` | Antigravity 唯讀分析入口 |
| `tools/ask-copilot.ps1` | Copilot Free 唯讀 worker；禁止 shell 與 write |
| `tools/ask-openrouter.ps1` | OpenRouter Free worker；使用 OpenCode plan agent |
| `tools/ask-grok.ps1` | Grok Build 免費試用 worker；單回合 plan mode |
| `tools/ask-local-qwen.ps1` | 本地 Qwen worker；透過 Ollama localhost API，不傳送資料到雲端 |
| `tools/invoke-ai.ps1` | 統一自動路由、敏感度隔離與失敗降級入口 |
| `tools/test-ai-workers.ps1` | 五個 worker 的靜態或 live JSON health check |
| `tools/ask-gemini.ps1` | 舊 Gemini wrapper，只供歷史追溯 |
| `start-codex.ps1` | 舊獨立 Codex CLI 啟動器；目前主要入口已是 Orca |

## GitHub 與版本規則

- 當前 repository，以及使用者在要求或專案脈絡中點名的 repository，其唯讀操作採持續授權；查看檔案、branch、commit、PR、Issue、Actions、Release 或下載內容供檢查時不再另行詢問。不得藉此自行遍歷無關的私人或組織 repository。
- 將本機或新產生內容送往 GitHub，或改變遠端狀態時才需要明確授權，例如 push、建立／修改／合併 PR、Issue、留言、Release、tag、設定、觸發 workflow 或重跑 job。當次要求已明確包含這些動作與目標時，不重複確認。
- 遠端寫入預設使用當前 repository 的功能分支與 PR；直接推送 protected／default branch 或任何 force push，必須明確點名目標與操作。
- 下載供檢查的內容不得自動執行 hooks 或遞迴初始化 submodules；Actions logs／artifacts 視為可能含敏感資料。
- 執行環境仍可能顯示無法由專案規則取消的系統級 sandbox 權限提示。
- `main` 保存已合併基線；變更先進功能分支與 Pull Request。
- 每個環境版本都必須更新 `VERSION_HISTORY.md`。
- 實作卡關與解法更新 `ENVIRONMENT_CHANGELOG.md`。
- 持久決策與下一步更新 `PROJECT_MEMORY.md`。
- 提交及推送前，掃描所有 changed／staged files，排除 token、密碼、API key、私人聯絡資料、裝置識別碼與不必要的本機路徑。
- API key 與登入憑證只保存在各 CLI 的本機安全儲存，不進入 repository。

## 目前下一步

下一步讓 Codex 在實際任務中累積各 provider 的成功率與驗證成本，再調整路由優先序；不得保存 prompt 或敏感內容作為遙測。
