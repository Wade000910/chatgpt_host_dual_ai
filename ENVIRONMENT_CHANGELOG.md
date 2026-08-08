# Environment changelog

這份文件記錄 Codex／Orca 工作環境的公開版本、實作結果、卡關與後續行動。它不保存原始聊天、登入憑證、配對碼、私人裝置資訊或不必要的本機路徑。

## Environment v0.3 — proposed

### 目標

- 將 Orca 發展為多 AI 調度中心，同時降低重複上下文與 token 消耗。

### 現況

- Codex 是 Orca 內目前唯一已驗證可用的主要代理。
- Antigravity 可透過既有 wrapper 執行按需的獨立審查，但尚未成為 Orca 內的常駐代理。
- 其他 Orca provider 尚未完成帳號設定，因此不能宣稱已形成完整多模型執行池。

### 協作策略提案

- Codex 擔任唯一 coordinator、最終編輯者與驗證者。
- 簡單修改與一般問答預設只使用 Codex。
- 只有任務可獨立切分時，才使用隔離 worktree 的 Orca workers 平行處理。
- 架構、安全審查或連續失敗兩次的問題，才呼叫 Antigravity；每個使用者請求最多兩次。
- 代理之間只傳遞精簡 brief：目標、限制、目標檔案或證據、交付物、通過條件；不傳完整聊天紀錄。
- 分歧以測試、benchmark、文件與實際執行結果裁決，不以模型投票決定。

### 建議量測

- 每個已驗證成果的 token／用量成本。
- 首次完成率與重做次數。
- 外部審查實際改變最終方案的比例。
- 平行 worker 的等待時間、衝突率與合併成本。

### 下一步

- 先以一個小任務比較 Codex-only 與 Codex＋一次 Antigravity review，再決定是否值得加入下一個付費 AI provider。

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
