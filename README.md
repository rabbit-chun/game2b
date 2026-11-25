# 小小夢魔：星夜理財夢

給小學生玩的繁體中文互動理財遊戲。玩家從家裡出發，用方向鍵走到早餐店或校園任務牌；探索時可直接看見並移動 Blender 製作的 3D 小玩家角色。每天選擇早餐、文具、橡皮擦、休閒或虛構投資方案，先預覽對存款和快樂值的影響再確認。挑戰共十天，分成兩關，每關五天並結算 90 分；完成第一關取得鑰匙，存款達成玩具目標取得第二把。遊戲包含簡單、普通、挑戰三種難度，並呈現部分延遲事件。

玩法參照[十天存錢挑戰](https://rabbit-chun.github.io/game1b/)的每日選擇、零用錢、存款目標、快樂值、延遲結果與結局規則。投資使用虛構星種；分散投資能降低集中風險，但不保證不損失。暖色像素場景與 Blender 製作的 3D 鑰匙保留。

## 線上遊玩與部署

目前部署目標是 GitHub Pages 專案根目錄，遊戲入口為根目錄 `index.html`，公開網址為 <https://rabbit-chun.github.io/game2b/>。本次版本識別連結為 <https://rabbit-chun.github.io/game2b/?release=0a45324a0366>。若瀏覽器仍顯示舊版，可使用版本連結重新載入。GitHub Pages 可直接由 `main` 分支根目錄發布；Netlify 的 publish directory 設為 `.`，不需建置命令。

## 從 Godot 重新匯出

1. 安裝 Godot 4.7.2，匯入 `godot/project.godot`。
2. 安裝 Godot 4.7.2 匯出範本。此專案使用 Web no-threads 範本。
3. 執行下方匯出腳本。腳本會輸出 Godot Web 檔案、以內容雜湊命名 PCK，並更新 HTML 載入路徑，避免 Pages/CDN 快取舊遊戲封包。
4. 提交根目錄的 HTML、JS、WASM、版本化 PCK 和 worklet 檔案並推送到 `main`。

也可在 Windows PowerShell 執行：

```powershell
powershell -ExecutionPolicy Bypass -File tools/export-web.ps1
```

`godot/assets/dream_explorer.glb` 是探索時使用的 Blender 3D 玩家模型，來源在 `assets/dream_explorer.blend`，可由 `tools/build_dream_explorer.py` 重建。`godot/assets/dream_key.glb` 是關卡獎勵鑰匙模型。繁體中文字型為 Noto Sans TC，隨附 OFL 授權說明。

## 專案文件

- `docs/project-brief.md`、`docs/requirements.md`：核准範圍與需求
- `docs/game-design-tournament.md`、`docs/visual-review.md`：概念賽與視覺決策
- `docs/traceability.md`、`docs/skills-audit.md`：需求追蹤與技能套用紀錄
- `docs/student-worksheet.md`、`docs/instructor-rubric.md`：教學活動材料
- `legacy-html/`：此前的靜態 HTML 原型存檔
