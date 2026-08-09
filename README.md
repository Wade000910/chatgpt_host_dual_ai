# Codex 主持的 Orca 多 AI 工作區

這個公開 repository 保存一套已實際驗證的 Windows／Orca 多 AI 協作環境。Codex 負責理解需求、分配工作、修改檔案與最終驗證；其他 AI 只接收最小必要 brief，協助唯讀分析、草稿或審查。

目前版本是 **Environment v0.6**。手機連線、三個雲端輔助來源與一個完全本地的 Qwen worker 都已驗證。

## 目前狀態

| 元件 | 狀態 | 用途 | 修改專案 |
|---|---|---|---|
| Codex | 已驗證 | 主持、決策、實作、測試、隱私掃描與最終交付 | 可以 |
| Antigravity | 已驗證，付費帳號 | 架構比較、深度分析、第二意見與審查 | 不可以 |
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

完整路由與操作方式見 [協作流程](docs/COLLABORATION_WORKFLOW.md)。

## 快速開始

1. 閱讀 [PROJECT_MEMORY.md](PROJECT_MEMORY.md)，取得目前決策與下一步。
2. 確認目前分支與工作區狀態：

   ```powershell
   git status --short --branch
   ```

3. 從 Orca 開啟此 workspace；Orca Mobile 只負責延續桌面工作階段，桌面 Orca 必須保持執行且電腦不可睡眠。
4. 需要唯讀 worker 時使用：

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-copilot.ps1 -Prompt "<PROMPT>"
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-openrouter.ps1 -Prompt "<SANITIZED_PROMPT>"
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-grok.ps1 -Prompt "<PROMPT>"
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-local-qwen.ps1 -Prompt "<PROMPT>"
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\ask-antigravity.ps1 -Prompt "<PROMPT>"
   ```

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
| `tools/ask-gemini.ps1` | 舊 Gemini wrapper，只供歷史追溯 |
| `start-codex.ps1` | 舊獨立 Codex CLI 啟動器；目前主要入口已是 Orca |

## GitHub 與版本規則

- `main` 保存已合併基線；變更先進功能分支與 Pull Request。
- 每個環境版本都必須更新 `VERSION_HISTORY.md`。
- 實作卡關與解法更新 `ENVIRONMENT_CHANGELOG.md`。
- 持久決策與下一步更新 `PROJECT_MEMORY.md`。
- 提交及推送前，掃描所有 changed／staged files，排除 token、密碼、API key、私人聯絡資料、裝置識別碼與不必要的本機路徑。
- API key 與登入憑證只保存在各 CLI 的本機安全儲存，不進入 repository。

## 目前下一步

下一步建立自動 health check，分開驗證 wrapper 啟動、UTF-8／特殊字元傳遞、provider 登入狀態與固定格式輸出，避免只靠固定字串測試造成假陽性。
