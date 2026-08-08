# Codex 主持的多 AI 工作區

這是一套在 Windows 與 Orca 上運作的多 AI 工作區。Codex 是主要助理、討論主持人與最終整合者；Google Antigravity CLI 提供深度分析與審查，GitHub Copilot Free CLI 提供低風險的免費優先草稿與獨立檢查，最後仍由 Codex 修改、驗證並交付。

目前 repository 也保存 FCO 影片分析專案的決策脈絡，讓不同 CLI 工作階段可以延續討論，不必每次重新說明背景。

工作環境的版本、遷移進度、卡關與解法記錄在 [`ENVIRONMENT_CHANGELOG.md`](ENVIRONMENT_CHANGELOG.md)。

## 目前具備的功能

- Codex CLI 作為唯一的主要操作介面。
- 使用指定前綴啟動正式雙 AI 討論；大型一般任務也允許 Codex 按效益自動請 Antigravity 協助一次。
- Codex 與 Antigravity 分別分析，再由 Codex 整理共同看法、分歧、結論與下一步。
- 可透過 `tools/ask-copilot.ps1` 將精簡任務交給 Copilot Free；wrapper 禁止 shell 與寫檔工具，適合作為唯讀 worker。
- Orca terminal worker 傳送含空白、中文或長 prompt 時使用 wrapper 的 `-PromptBase64`，避免 Windows 命令列 quoting。可見 terminal 完成後會回到提示符、不會退出；先等待 `tui-idle`，再輪詢 `terminal read` 或 `terminal show` 的完成標記。
- CLI 底部狀態列顯示 Codex 模型、context、5 小時額度、每週額度與 Git 分支。
- Codex 原生本機 Memories，協助跨對話回想。
- `PROJECT_MEMORY.md` 保存明確的專案事實、決策、理由、未決問題與下一步。
- 啟動時預設續接此資料夾最近一次 Codex 對話。
- GitHub 使用功能分支與 Pull Request，避免未確認的功能直接進入 `main`。
- 討論與審查預設唯讀，只有使用者明確要求實作時才修改專案。

## 運作架構

```text
使用者
  ↓
Codex CLI（主要助理、主持、判斷、修改與驗證）
  ↓  正式雙 AI 前綴，或大型任務的有益分工
Antigravity CLI（Google 輔助分析、草稿、測試策略與審查）
  ↓
Codex CLI（比較證據、保留分歧、提出主持結論）
```

使用者對所有產品與技術決策保有最終權限。

## 雙 AI 觸發方式

訊息以任一前綴開頭時，Codex 必須呼叫 Antigravity 執行正式雙 AI 流程：

- `雙AI：`
- `雙 AI：`
- `Dual AI:`

範例：

```text
雙AI：請比較 FCO 第一版應先做 Python 離線原型，還是 Android 即時版本。
```

雙 AI 回答固定整理為：

1. 共同看法
2. 分歧與風險
3. 主持結論
4. 下一步

一般大型任務中，Codex 也可以主動請 Antigravity 完成獨立研究、方案比較、草稿、測試策略或 review。簡單問題不呼叫；通常只呼叫一次，重大分歧才追加一次。每個使用者問題最多呼叫 Antigravity 兩次。

Antigravity 不直接修改專案檔案。所有修改、測試、個資掃描與最終判斷仍由 Codex 負責。呼叫失敗時，Codex 必須明確報告，不能假裝取得第二 AI 意見。

## 記憶設計

本專案使用兩層記憶：

### Codex 本機 Memories

`start-codex.ps1` 會在每次啟動時開啟：

```text
features.memories=true
memories.generate_memories=true
memories.use_memories=true
tui.status_line=["model-with-reasoning","context-remaining","five-hour-limit","weekly-limit","git-branch"]
```

本機 Memories 由 Codex 在背景整理，適合輔助回想，但不保證在對話結束後立即產生。

### 專案記憶

`PROJECT_MEMORY.md` 是可檢查、可版本控制的精簡專案脈絡。`AGENTS.md` 要求 Codex：

- 每次開始專案討論前先讀取它。
- 重要討論後只記錄持久資訊。
- 區分已確認事實、決策與尚未驗證的提案。
- 使用者最新的明確指示永遠優先。

記憶中不得存放密碼、Token、私鑰、登入憑證、完整聊天逐字稿、不必要的個人資料或 AI 私有推理過程。

## GitHub 工作流程

遠端 repository：`Wade000910/chatgpt_host_dual_ai`

目前 repository 是 **Public**。任何人都能查看 repository 中的檔案與 Git 歷史，因此提交前必須檢查並排除憑證及非必要個人資料。

初始基線保存在 `main`。後續功能預設流程：

1. Codex 建立功能分支。
2. 完成修改與適當驗證。
3. 建立清楚的 Git commit。
4. 推送功能分支至 GitHub。
5. 建立 Pull Request。
6. 回報變更摘要、驗證結果與 PR 連結。

除非使用者明確授權，否則不直接把未審查的功能變更推送到 `main`，也不刪除 repository 或改成 Public。

## 檔案說明

| 路徑 | 用途 |
|---|---|
| `AGENTS.md` | Codex 的持久工作規則、雙 AI 流程、安全規則與記憶規則 |
| `PROJECT_MEMORY.md` | FCO 與本工作區的持久專案脈絡 |
| `start-codex.ps1` | 啟動 Codex、啟用 Memories，並預設續接最近對話 |
| `tools/ask-antigravity.ps1` | 將最小必要問題送給 Antigravity，是正式雙 AI 與自動分工入口 |
| `tools/ask-copilot.ps1` | 將低風險精簡任務送給 Copilot Free，並禁止 shell 與寫檔工具 |
| `tools/ask-gemini.ps1` | 舊 Gemini wrapper；Google 個人版已回報不再支援此 client，不是預設工作流 |
| `.gitignore` | 避免提交環境檔、金鑰、憑證與暫存輸出 |
| `AGENTS.backup.md` | 早期規則備份，僅供追溯 |

## 安裝需求

- Windows PowerShell
- Codex CLI，且已完成 `codex login`
- Antigravity CLI，且已完成登入
- GitHub Copilot CLI，且 Copilot Free 已啟用並完成登入
- Git for Windows
- GitHub CLI，且已完成 `gh auth login`

可以使用以下命令檢查：

```powershell
codex --version
git --version
gh --version
```

## 啟動方式

預設啟用記憶並續接此資料夾最近一次對話：

```powershell
powershell -ExecutionPolicy Bypass -File .\start-codex.ps1
```

開啟全新對話，但仍使用專案記憶與本機 Memories：

```powershell
powershell -ExecutionPolicy Bypass -File .\start-codex.ps1 -New
```

## 已記錄的 FCO 決策

目前建議先建立 Python 離線影片分析原型，優先驗證分析品質與使用者價值。如果即時回饋可能是不可缺少的核心價值，再搭配極小型 Android 裝置效能測試；尚未確認即時性之前，不直接承擔完整 Android App 的相機、模型轉換、裝置相容性、延遲、耗電與發熱風險。

完整的已確認事實、理由、未決問題與下一步請參閱 `PROJECT_MEMORY.md`。

## 安全原則

- 不把 GitHub Token、密碼、API key 或私鑰提交到 repository。
- 不提交私人電子郵件、電話、住址、身分證件、裝置識別碼或非必要的本機使用者路徑。
- 公開的 GitHub 帳號與 repository 網址只在識別專案確有需要時保留。
- 傳送給 Antigravity 的內容限於回答問題所需的最小脈絡。
- 討論與審查預設不修改檔案。
- 不安裝套件或執行破壞性命令，除非使用者明確授權。
- 不製造虛假的雙 AI 共識，重大分歧必須保留。
- GitHub 登入使用官方瀏覽器裝置授權，憑證由系統安全儲存處理。

## 專案狀態

這個 repository 目前主要是 AI 協作環境與 FCO 決策基礎，尚未包含 FCO 的正式影片分析實作。下一個產品步驟是定義一週 Python baseline 實驗、代表性影片與明確成功門檻。
