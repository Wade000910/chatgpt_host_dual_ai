# Environment changelog

這份文件記錄 Codex／Orca 工作環境的公開版本、實作結果、卡關與後續行動。它不保存原始聊天、登入憑證、配對碼、私人裝置資訊或不必要的本機路徑。

## Environment v0.3 — proposed

### 目標

- 將 Orca 發展為多 AI 調度中心，同時降低重複上下文與 token 消耗。

### 現況

- Codex 與付費 Antigravity 是目前已驗證可用的主要代理。
- 更正：使用者已有付費 Antigravity；CLI 已安裝、登入、位於 PATH、可由 wrapper 呼叫，且在 Orca `Settings → Agents` 中已偵測並啟用。
- Orca 的 usage panel 仍因舊 Gemini OAuth tracking 停用而把 Antigravity 額度標成 unavailable；這是額度偵測問題，不是代理連線或付費 entitlement 失效。
- 其他 Orca provider 尚未完成帳號設定，因此不能宣稱已形成完整多模型執行池。

### 協作策略提案

- Codex 擔任唯一 coordinator、最終編輯者與驗證者。
- 採用 `free-first, Codex-last`：適合的低風險工作先使用已驗證的免費代理，Codex 只讀取壓縮後的候選結果、diff 與證據。
- Orca 的非模型規則負責路由與額度門檻，避免為了選擇代理本身消耗 Codex token。
- 只有任務可獨立切分時，才使用隔離 worktree 的 Orca workers 平行處理。
- 架構、安全審查或連續失敗兩次的問題，才呼叫 Antigravity；每個使用者請求最多兩次。
- 代理之間只傳遞精簡 brief：目標、限制、目標檔案或證據、交付物、通過條件；不傳完整聊天紀錄。
- 分歧以測試、benchmark、文件與實際執行結果裁決，不以模型投票決定。

### 建議量測

- 每個已驗證成果的 token／用量成本。
- 首次完成率與重做次數。
- 外部審查實際改變最終方案的比例。
- 平行 worker 的等待時間、衝突率與合併成本。
- 每個 provider 的免費額度命中率，以及因此節省的 Codex 額度。

### 免費資源盤點（2026-08-08）

- Antigravity CLI 是 Google 自 2026-06-18 起提供給 Gemini CLI 個人免費、Google AI Pro 與 Ultra 使用者的正式後繼工具；兩者不得重複計算成兩份額度。
- Antigravity 使用 Gemini 模型，但產品層包含新的 agent runtime、subagents、skills、hooks 與 plugins；現有 Antigravity wrapper 是 Google 免費優先池的接入點。
- Grok 官方標示可免費開始，但 coding CLI 的可依賴免費額度未明，僅列為實驗候選。
- Kimi Code 官方目前屬於會員權益；MiniMax Coding Plan 以付費方案為主，兩者不列入穩定免費池。
- 免費不代表適合傳送所有資料；每個 provider 仍須遵守最小上下文與公開 repository 的隱私規則。

### 下一步

- 從 Orca 啟動已啟用的 Antigravity agent，測試一次 Antigravity 先行、Codex 最終驗證的完整流程；額外追查 Orca 額度面板的錯誤狀態。

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
