# Codex 主持的雙 AI 工作區

這是一套在 Windows 上運作的 Codex CLI 工作區。Codex 是主要助理、討論主持人與最終整合者；使用者需要第二意見時，可以用特定前綴要求 Codex 呼叫 Antigravity CLI 獨立分析。

目前 repository 也保存 FCO 影片分析專案的決策脈絡，讓不同 CLI 工作階段可以延續討論，不必每次重新說明背景。

## 目前具備的功能

- Codex CLI 作為唯一的主要操作介面。
- 使用指定前綴才啟動雙 AI 討論，普通問題不浪費第二個 AI 的額度。
- Codex 與 Antigravity 分別分析，再由 Codex 整理共同看法、分歧、結論與下一步。
- Codex 原生本機 Memories，協助跨對話回想。
- `PROJECT_MEMORY.md` 保存明確的專案事實、決策、理由、未決問題與下一步。
- 啟動時預設續接此資料夾最近一次 Codex 對話。
- GitHub 使用功能分支與 Pull Request，避免未確認的功能直接進入 `main`。
- 討論與審查預設唯讀，只有使用者明確要求實作時才修改專案。

## 運作架構

```text
使用者
  ↓
Codex CLI（主要助理、主持、判斷與實作）
  ↓  僅在雙 AI 前綴出現時
Antigravity CLI（獨立第二意見）
  ↓
Codex CLI（比較證據、保留分歧、提出主持結論）
```

使用者對所有產品與技術決策保有最終權限。

## 雙 AI 觸發方式

只有訊息以任一前綴開頭時，Codex 才會呼叫 Antigravity：

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

每個使用者問題最多呼叫 Antigravity 兩次。呼叫失敗時，Codex 必須明確報告，不能假裝取得第二 AI 意見。

## 記憶設計

本專案使用兩層記憶：

### Codex 本機 Memories

`start-codex.ps1` 會在每次啟動時開啟：

```text
features.memories=true
memories.generate_memories=true
memories.use_memories=true
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

目前 repository 是 **Private**。只有擁有者與獲邀協作者能查看這份說明。

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
| `tools/ask-antigravity.ps1` | 將最小必要問題送給 Antigravity CLI |
| `tools/ask-gemini.ps1` | 早期保留的 Gemini wrapper，目前不是正式雙 AI 流程 |
| `.gitignore` | 避免提交環境檔、金鑰、憑證與暫存輸出 |
| `AGENTS.backup.md` | 早期規則備份，僅供追溯 |

## 安裝需求

- Windows PowerShell
- Codex CLI，且已完成 `codex login`
- Antigravity CLI，且已完成登入
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
- 傳送給第二 AI 的內容限於回答問題所需的最小脈絡。
- 討論與審查預設不修改檔案。
- 不安裝套件或執行破壞性命令，除非使用者明確授權。
- 不製造虛假的雙 AI 共識，重大分歧必須保留。
- GitHub 登入使用官方瀏覽器裝置授權，憑證由系統安全儲存處理。

## 專案狀態

這個 repository 目前主要是 AI 協作環境與 FCO 決策基礎，尚未包含 FCO 的正式影片分析實作。下一個產品步驟是定義一週 Python baseline 實驗、代表性影片與明確成功門檻。
