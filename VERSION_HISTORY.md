# Version history

環境版本描述可重現的能力里程碑；Git commit 保存更細的逐次修改。每次新增、移除或改變 provider、路由、安全邊界、手機連線或記憶方式，都必須新增版本紀錄。

## v0.9 — 2026-08-15 — Antigravity 監督審查

狀態：目前版本

目標：讓 Antigravity 在實質專案工作的關鍵檢查點獨立找問題，並與 Codex 進行有證據、有限回合的分歧處理。

主要交付：

- 新增高影響方案、重大實作及研究／安全／隱私／量測宣稱的監督觸發點。
- 定義「Antigravity 發現問題 → Codex 核對證據 → 修正或一次聚焦複核」流程。
- 每個使用者請求通常一次、最多兩次 Antigravity 呼叫。
- 使用 Blocker／Warning／Notice 與 APPROVED／REJECTED／NEEDS_MORE_EVIDENCE 統一審查結果。
- 記錄 GitHub 唯讀操作的持續授權，以及遠端寫入／發布前的明確授權邊界。
- Codex 保留修改、驗證與最終交付責任；Antigravity 維持唯讀。

限制：

- 監督是檢查點式而非持續旁聽，不能保證發現所有問題。
- 未解分歧必須明確呈現，必要時交由使用者決定。

## v0.8 — 2026-08-09 — 零設定統一路由與健康檢查

狀態：已完成

目標：讓 Codex 在後續 session 直接協作，不再要求使用者逐一選擇或設定 AI provider。

主要交付：

- 新增 `tools/invoke-ai.ps1`，依任務類型、敏感度與 provider 狀態自動路由及降級。
- 私人 prompt 強制只走 Local Qwen，絕不自動降級至雲端。
- 新增 `tools/test-ai-workers.ps1`，支援零額度靜態檢查與五 provider live check。
- 五個 live check 全數通過；統一路由實測私人分類走 Local Qwen、公開 review 走 Grok。
- AGENTS 規則固定 Codex 使用統一入口，不要求使用者重做既有設定。

## v0.7 — 2026-08-09 — Worker 實題基準與參數修正

狀態：已完成

目標：用同一個安全 review 任務驗證五條路徑，並修正 Windows `.cmd` 對 prompt 的二次解析。

主要交付：

- Copilot 改為直接呼叫 Node loader；OpenRouter 改為直接呼叫 OpenCode executable。
- 實題結果：OpenRouter 約 11.4 秒、Grok 約 14.6 秒、Antigravity 約 17.2 秒、Copilot 約 37.0 秒，四者均找到三項指定風險。
- Local Qwen 約 5.5 秒，但未遵守格式並誤解程式語意，因此禁止承擔安全審查或最終判斷。
- 固定路由以資料敏感度與任務風險優先，延遲只作次要依據。

已知限制：

- OpenRouter 會附加 CLI 狀態文字；Antigravity 在含 `|` 的格式測試後出現 shell 雜訊，Codex 必須清理並驗證。
- 單次樣本只能建立安全下限，不能視為永久模型排名。

## v0.6 — 2026-08-09 — 本地 Qwen／Ollama worker

狀態：已完成

目標：建立不使用雲端額度、資料不離開電腦的背景 worker。

主要交付：

- 硬體確認為 8GB NVIDIA VRAM、16GB system RAM，適合 4B～9B 量化模型。
- 安裝 Ollama 0.32.6 與 `qwen3.5:4b`（約 3.4GB）。
- 確認模型 100% GPU offload。
- thinking 關閉後固定回應測試約 2.4 秒、約 65 tokens/s。
- 新增 `tools/ask-local-qwen.ps1`，只呼叫 localhost API，不提供工具。

已知限制：

- 4B 模型品質不等同大型雲端模型；Codex 仍須驗證輸出。
- 目前固定 8K context，避免 8GB VRAM 因 KV cache 壓力溢出。
- Ollama 必須在本機背景執行。

## v0.5 — 2026-08-09 — Grok Build 免費試用

狀態：已完成

目標：驗證 xAI 官方 Grok Build CLI 的免費 OAuth 路徑，並以嚴格唯讀設定加入實驗性 worker pool。

主要交付：

- 安裝 Grok Build 1.0.0，加入使用者 PATH。
- 以 xAI 官方 OAuth 完成登入，沒有建立 API key 或啟用 API billing。
- 完成 headless 單回合測試，約 6.5 秒回覆 `GROK_FREE_OK`。
- 新增 `tools/ask-grok.ps1`，固定 plan mode、暫存目錄、停用 subagents 與 web search、最多一回合。

已知限制：

- xAI 只標示 available to try for free，未承諾永久或固定免費額度。
- Grok Build 免費試用與 xAI API 計費是不同 entitlement；不得把 API 視為免費。

## v0.4 — 2026-08-09 — 文件與 checkpoint

狀態：已完成

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
