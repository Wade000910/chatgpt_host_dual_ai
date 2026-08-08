# Version history

環境版本描述可重現的能力里程碑；Git commit 保存更細的逐次修改。每次新增、移除或改變 provider、路由、安全邊界、手機連線或記憶方式，都必須新增版本紀錄。

## v0.4 — 2026-08-09 — 文件與 checkpoint

狀態：目前版本

目標：讓未參與前期工作的協作者能從 GitHub 理解現況、歷史、實際流程與下一步。

主要交付：

- 重整 README 為現況入口。
- 新增多 AI 協作 runbook。
- 建立獨立版本歷史。
- 將環境擴充暫停點寫入專案記憶。
- 正規化 agent 規則，使其反映 Codex、Antigravity、Copilot Free 與 OpenRouter Free 的實際分工。

## v0.3 — 2026-08-08 至 2026-08-09 — 多 AI 免費優先池

狀態：已完成

目標：在 Codex 最終負責的前提下，加入可節省 Codex 額度的唯讀輔助資源。

主要交付：

- 確認付費 Antigravity CLI 已安裝、登入且可調用。
- 啟用 GitHub Copilot Free，安裝 Copilot CLI 1.0.78。
- 新增 `tools/ask-copilot.ps1`，禁止 shell 與 write。
- 安裝 OpenCode 1.18.15，連接 OpenRouter。
- 新增 `tools/ask-openrouter.ps1`，固定使用 `openrouter/free` 與 plan agent。
- 完成 Copilot、Antigravity 與 OpenRouter 的最小唯讀測試。

已知限制：

- 尚未實作完全自動、額度感知的 provider router。
- OpenRouter 免費模型供應與品質會變動。
- Grok 尚未接入。

## v0.2 — 2026-08-08 — Orca 與手機連線

狀態：已完成

目標：將主要工作環境從獨立 Codex CLI 遷移至 Orca，並讓 iPhone 可延續桌面工作階段。

主要交付：

- 確認 Orca runtime、Codex 設定與選裝 skills。
- 完成 Orca Mobile 配對。
- 以行動網路驗證 prompt、完成通知與回覆內容同步。
- 停用插電模式自動睡眠以維持桌面 host 可用。
- 保留 Chrome Remote Desktop 作為選用完整桌面備援。

已知限制：

- 手機不是獨立執行環境；桌面 Orca 必須執行且電腦不可睡眠。
- 手機文字可能比完成通知稍晚顯示。
- 舊 Codex sessions／history／runtime database 未直接匯入 Orca。

## v0.1 — 2026-08-03 — Codex／Antigravity 基線

狀態：已完成

目標：建立可版本控制、安全且能保存決策的雙 AI 工作區。

主要交付：

- 建立 Codex 主持、Antigravity 輔助的正式觸發規則。
- 建立 `PROJECT_MEMORY.md`。
- 建立 Antigravity 與舊 Gemini wrappers。
- 建立 public GitHub repository 的隱私掃描、功能分支與 Pull Request 規則。
- 記錄 FCO 第一階段偏向 Python 離線影片分析原型的提案。
