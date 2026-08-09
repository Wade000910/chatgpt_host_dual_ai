# Environment changelog

這份文件按版本記錄實作過程、卡關、原因與解法。版本摘要見 `VERSION_HISTORY.md`；目前狀態與下一步見 `PROJECT_MEMORY.md`。任何憑證、配對碼、私人資料與不必要的本機路徑都不得出現在這裡。

## v0.5 — Grok Build 免費試用

### 完成

- 官方產品頁確認 Grok Build 目前標示 available to try for free；消費者 OAuth entitlement 與付費 xAI API 分開處理。
- 使用 xAI 官方 installer 安裝 Grok Build 1.0.0。
- 官方 OAuth 登入成功，沒有建立 xAI API key、購買 credits 或開啟 monthly billing。
- 以 plan mode、暫存目錄、停用 subagents／web search、最多一回合完成 headless 測試，約 6.5 秒回覆 `GROK_FREE_OK`。
- 新增 `tools/ask-grok.ps1`，支援純文字與 Base64 UTF-8 brief。

卡關與解法：

| 狀況 | 原因 | 解法 |
|---|---|---|
| 官方 installer 第一次沒有執行 | Git Bash 已安裝但不在 PATH | 使用 Git for Windows 的標準 `bash.exe` 路徑執行官方腳本 |
| installer 只更新 Bash PATH | Windows 與 PowerShell 不讀 `.bashrc` | 將官方 Grok bin 目錄加入使用者 PATH |
| Orca 建立 OAuth terminal 等待 handle 逾時 | terminal adoption 沒有在期限內完成 | 在背景啟動 `grok login --oauth`，由瀏覽器完成本機 callback |

已知限制：

- 免費試用額度未由官方承諾為固定或永久資源。
- xAI API 明確按 token 計費，本環境未接入 API billing。

## v0.4 — 文件與 checkpoint

### 完成

- 將 README 改為現況導覽，而不是沿用舊雙 AI 說明。
- 新增 `docs/COLLABORATION_WORKFLOW.md` 與 `VERSION_HISTORY.md`。
- 將已驗證 provider、未接入候選、路由規則與恢復工作步驟分開記錄。
- 正規化 `AGENTS.md` 的 Markdown 與多 AI 規則。

## v0.3 — 多 AI 免費優先池

### Antigravity

- 已確認使用者是付費 Antigravity 帳號；CLI 已安裝、登入、位於 PATH 並可由 wrapper 呼叫。
- Orca Agents 可偵測並啟用 Antigravity。
- Orca usage panel 因舊 Gemini OAuth tracking 停用而顯示 unavailable；這是額度顯示問題，不是代理失效。
- 首次唯讀策略審查約 72 秒完成，Git 工作樹乾淨。

卡關與解法：

| 狀況 | 原因 | 解法 |
|---|---|---|
| Orca headless 測試沒有結果 | 缺少 Antigravity command permission | 加入必要 permission 旗標後重試 |
| `terminal send` 傳長 prompt 失敗 | Windows quoting | 改用 wrapper／直接 CLI；長 brief 使用 Base64 |
| 把 Antigravity 誤列成免費資源 | 未先確認帳號方案 | 更正為付費資源，不與 Gemini 重複計算額度 |

### GitHub Copilot Free

- GitHub 帳號已啟用 Copilot Free。
- 安裝 GitHub Copilot CLI 1.0.78，認證與最小回應測試成功。
- 新增 `tools/ask-copilot.ps1`；關閉 custom instructions，deny shell 與 write。
- Orca terminal worker 成功讀回英文與 Base64 UTF-8 測試標記。

卡關與解法：

| 狀況 | 原因 | 解法 |
|---|---|---|
| `npm.ps1` 被阻擋 | Windows PowerShell Execution Policy | 使用 `npm.cmd` |
| Orca command 含空白 prompt 解析失敗 | Windows quoting | wrapper 支援 `-PromptBase64` |
| 等待 terminal exit 逾時 | 可見 terminal 完成後回到 shell，不退出 | 等待 idle 後輪詢 output marker |
| `tui-idle` 太早觸發 | shell 短暫 idle 早於模型輸出 | 再用 `terminal read`／`terminal show` 確認標記 |

測試：

- `COPILOT_OK`
- `COPILOT_WRAPPER_OK`
- `ORCA_COPILOT_WORKER_OK`
- `BASE64_WORKER_OK`
- 與 Antigravity 的同題微型比較：Copilot 約 12.9 秒、Antigravity 約 10.5 秒；兩者均保留全部要求。單一樣本不足以排名。

### OpenRouter Free／OpenCode

- 安裝 OpenCode 1.18.15。
- 以 OpenRouter 官方 API key 完成本機 provider 認證；憑證不在 repository。
- 固定使用 `openrouter/free`，只路由免費模型。
- 新增 `tools/ask-openrouter.ps1`；使用 plan agent、暫存目錄與 Base64 UTF-8 brief。

卡關與解法：

| 狀況 | 原因 | 解法 |
|---|---|---|
| `opencode.ps1` 被阻擋 | Windows PowerShell Execution Policy | 固定使用 `opencode.cmd` |
| Orca terminal 無法正常輸入英文 key | 中文輸入法與 terminal focus | 透過 Orca terminal input channel 傳送，不在聊天顯示 key |
| 第一次 Authorization header 無效 | 錯誤文字被保存成 credential | 登出錯誤 credential；只驗證剪貼簿 key 的前綴、單行與長度後重新登入 |
| `run --help` 曾回報 `.config/opencode` EEXIST | OpenCode Windows 初始化的暫時競爭 | 確認路徑是正常資料夾且無殘留程序後重試成功 |

測試：

- `OPENROUTER_FREE_OK`，約 5.4 秒。
- `OPENROUTER_WRAPPER_OK`，Base64 中文 brief 成功。
- 所有測試後 Git 工作樹均無非預期變更。

### v0.3 checkpoint

- 已驗證：Codex、付費 Antigravity、Copilot Free、OpenRouter Free／OpenCode。
- 尚未接入：Grok。
- 尚未完成：完全自動、額度感知的 provider router；多 provider 真實 review benchmark。

## v0.2 — Orca 與手機連線

### 完成

- 將主要操作環境遷移到 Orca。
- 確認選裝自 `mattpocock/skills` 的 `grill-me` 與 `grilling` 可用。
- 完成 Orca Mobile 與 iPhone 配對。
- 以 4G／5G 驗證 prompt、完成通知與回覆內容。
- 插電模式停用自動睡眠；電池模式保留原設定。

卡關與解法：

| 狀況 | 原因 | 解法 |
|---|---|---|
| PowerShell 顯示中文亂碼 | Windows PowerShell 5.1 預設編碼 | 讀取 Markdown 時指定 `-Encoding utf8` |
| `codex.ps1` 被阻擋 | Windows Execution Policy | 使用 `codex.cmd` 或 `-ExecutionPolicy Bypass` |
| Windows Home 無法作為 RDP host | 系統版本限制 | Orca Mobile 為主要入口；Chrome Remote Desktop 為備援 |
| 手機先收到完成通知、稍後才看到文字 | Relay／行動網路／UI hydration 延遲 | 延遲目前可接受；必要時刷新或切 raw terminal |
| GitHub CLI 憑證失效 | 舊授權無效 | 重新執行官方 `gh auth login` |

已知限制：

- 桌面 Orca 必須保持執行，電腦不可睡眠。
- 舊 Codex sessions、history 與 runtime database 尚未匯入 Orca。

## v0.1 — Codex／Antigravity 基線

### 完成

- 建立 Codex 主持、Antigravity 輔助的雙 AI 規則。
- 建立可版本控制的 `PROJECT_MEMORY.md`。
- 建立 Codex、Antigravity 與舊 Gemini PowerShell wrappers。
- 建立 public repository 隱私、安全、功能分支與 Pull Request 規則。
