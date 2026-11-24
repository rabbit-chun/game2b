# 小小夢魔：星夜理財夢

給小學生玩的繁體中文生活理財遊戲。Godot 4 專案採「月光玩具盒」視覺，以低多邊形月夜校園和 Blender 製作的鑰匙模型呈現兩關互動：願望雜貨店預算分配、星苗花園分散風險。每關通過後取得鑰匙並計分，結尾顯示學習成果。

## 線上遊玩與部署

目前部署目標是 GitHub Pages 專案根目錄，遊戲入口為根目錄 `index.html`。GitHub Pages 可直接由 `main` 分支根目錄發布；Netlify 的 publish directory 設為 `.`，不需建置命令。

## 從 Godot 重新匯出

1. 安裝 Godot 4.7.2，匯入 `godot/project.godot`。
2. 安裝 Godot 4.7.2 匯出範本。此專案使用 Web no-threads 範本。
3. 在 **Project → Export** 選擇 **Web**，輸出到專案根目錄的 `index.html`。
4. 提交根目錄所有 `index.*` 匯出檔案並推送到 `main`。

也可在 Windows PowerShell 執行：

```powershell
C:\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path godot --export-release Web ..\index.html
```

`godot/assets/dream_key.glb` 是遊戲使用的 Blender 模型；原始 `.blend` 與可重建腳本在 `assets/` 和 `tools/`。繁體中文字型為 Noto Sans TC，隨附 OFL 授權說明。

## 專案文件

- `docs/project-brief.md`、`docs/requirements.md`：核准範圍與需求
- `docs/game-design-tournament.md`、`docs/visual-review.md`：概念賽與視覺決策
- `docs/traceability.md`、`docs/skills-audit.md`：需求追蹤與技能套用紀錄
- `docs/student-worksheet.md`、`docs/instructor-rubric.md`：教學活動材料
- `legacy-html/`：此前的靜態 HTML 原型存檔

