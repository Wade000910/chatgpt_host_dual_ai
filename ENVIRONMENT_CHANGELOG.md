# Environment changelog

這份文件記錄 Codex／Orca 工作環境的公開版本、實作結果、卡關與後續行動。它不保存原始聊天、登入憑證、配對碼、私人裝置資訊或不必要的本機路徑。

## Environment v0.2 — 2026-08-08

### 目標

- 將主要操作環境從獨立 Codex CLI 遷移到 Orca。
- 保留既有專案規則、記憶、skills 與 Git 工作流程。
- 讓 Orca Mobile 可以從 iPhone 經行動網路控制桌面端代理工作階段。

### 已完成

- 確認 Orca 已建立獨立 Codex runtime，並帶入 Codex 設定、登入狀態、狀態列與專案信任設定。
- 確認 Orca 的 plugins 目前與既有 Codex plugins 共用來源，而 sessions、history、memories 與 runtime databases 維持分離。
- 確認選裝自 `mattpocock/skills` 的 `grill-me` 與 `grilling` 可在 Orca 使用。
- 確認專案 PowerShell 腳本皆可通過語法解析。
- 完成 Orca Mobile 與 iPhone 配對。
- 使用 4G／5G 驗證 Orca Relay：手機可送出 prompt、收到完成通知及回覆內容。
- 將插電模式的自動睡眠設為停用，避免桌面 Orca host 因睡眠離線；電池模式維持原設定。

### 迭代與卡關

| 狀況 | 判斷 | 處理結果 |
|---|---|---|
| PowerShell 顯示中文亂碼 | Markdown 是有效 UTF-8；Windows PowerShell 5.1 預設解碼不符 | 讀取時明確使用 `-Encoding utf8` |
| 一般 PowerShell 無法直接執行 `codex` | npm 的 `codex.ps1` shim 被執行原則阻擋 | 可使用 `codex.cmd`；舊啟動腳本透過 `-ExecutionPolicy Bypass` 啟動 |
| Windows Home 無法作為 Microsoft RDP host | Windows 內建 RDP host 需要 Pro edition | 不採用 RDP |
| 最初將需求理解為完整 Windows 桌面遙控 | 安裝了 Chrome Remote Desktop Host | 保留為選用備援；Orca Mobile 改為主要手機入口 |
| Orca Mobile 開啟工作階段時回覆文字稍有延遲 | Relay、行動網路與 Chat UI hydration 存在同步延遲 | 通知與內容均能抵達，目前可接受；必要時切換 raw terminal 或刷新 worktree |
| GitHub CLI 驗證失效 | `gh auth status` 回報既有憑證無效 | 重新執行官方 `gh auth login` 後才能自動建立 Pull Request |

### 已知限制

- 手機不是獨立執行環境；桌面 Orca 必須保持執行且電腦不可睡眠。
- Orca Mobile 的文字呈現可能比完成通知稍慢。
- 舊 Codex sessions、history 與 memories 尚未直接匯入 Orca databases；在沒有官方匯入機制前不覆蓋資料庫。
- Chrome Remote Desktop Host 目前仍安裝，是否移除尚未決定。

### 下一步

- 重新完成 GitHub CLI 授權並建立本次文件更新的 Pull Request。
- 決定是否移除 Chrome Remote Desktop 備援。
- 將舊的 `start-codex.ps1` 標記為 legacy，並補上 Orca-first 的啟動與健康檢查流程。

## Environment v0.1 — 2026-08-03

### 已完成

- 建立 Codex 主持、Antigravity 輔助的雙 AI 規則。
- 建立 `PROJECT_MEMORY.md` 作為可版本控制的耐久專案記憶。
- 設定 GitHub public repository、安全規則、功能分支與 Pull Request 工作流程。
- 建立 Codex、Antigravity 與舊 Gemini PowerShell wrappers。
