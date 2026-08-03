# ChatGPT／Codex 主持的雙 AI 工作區（Windows）

這份設定讓 Codex CLI 擔任主要介面與主持人，必要時從同一個 Codex 對話中呼叫 Gemini CLI，最後由 Codex 整理共同答案。

## 架構

你
→ Codex CLI（主持、判斷、整合）
→ Gemini CLI（獨立顧問）
→ Codex CLI（比較、追問、共同結論）

## 事前需求

PowerShell 中確認兩個指令都能使用：

```powershell
codex --version
gemini --version
```

第一次使用 Codex 時：

```powershell
codex login
```

Gemini 必須已經完成登入；你目前截圖已顯示 `Authentication succeeded`。

## 測試 Gemini 子顧問

在本資料夾開啟 PowerShell，執行：

```powershell
"只回答：Gemini 子顧問連線成功" | powershell -ExecutionPolicy Bypass -File .\tools\ask-gemini.ps1
```

若畫面出現 Gemini 回覆，即代表 Codex 日後可以呼叫它。

## 啟動 Codex 主介面

```powershell
powershell -ExecutionPolicy Bypass -File .\start-codex.ps1
```

預設會啟用 Codex 本機記憶，並續接這個資料夾最近一次對話。若要開啟全新對話：

```powershell
powershell -ExecutionPolicy Bypass -File .\start-codex.ps1 -New
```

重要的專案決策、理由、未決問題與下一步會另外整理在 `PROJECT_MEMORY.md`，因此即使開新對話也能恢復必要脈絡。請勿把密碼、Token 或其他機密資料寫入專案記憶。

## GitHub 工作流程

遠端專案為 private repository：`Wade000910/chatgpt_host_dual_ai`。

初始基線保存在 `main`；後續功能由 Codex 建立功能分支、完成驗證、推送並建立 Pull Request。未經確認的功能改動不直接推送至 `main`。

或直接：

```powershell
codex
```

## 使用方式

在 Codex 介面中輸入：

```text
雙AI：請比較 FCO 第一版應先做 Python 離線原型，還是 Android 即時版本。
```

Codex 會依 `AGENTS.md` 的規則：

1. 先形成自己的初步判斷。
2. 透過 `tools/ask-gemini.ps1` 呼叫 Gemini 獨立回答。
3. 比較雙方共識與分歧。
4. 必要時再向 Gemini 追問一次。
5. 由 Codex 提供共同答案。

## 安全原則

- 預設只討論與讀取，不修改專案。
- 只有你明確要求實作時，Codex 才可改檔案。
- 每個問題最多呼叫 Gemini 兩次，避免浪費額度。
- Gemini 呼叫失敗時，Codex必須直接說明，不得假裝已完成雙 AI 討論。
