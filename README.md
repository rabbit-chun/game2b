# 小小夢魔：星夜理財夢

給小學生玩的繁體中文生活理財入門遊戲。原創星夜校園插畫呼應附件的俯視校園與夜間燈火氣氛，玩法包括兩個互動關卡、逐關得分、解題取得鑰匙，以及最後的學習成果回顧。每關有三題，每題答對得 30 分；全遊戲滿分 180 分。完成一關即可取得該關鑰匙，即使有題目答錯也可以繼續，鼓勵從解說中學習。

## 本機預覽

直接以瀏覽器開啟 `index.html` 即可。遊戲不需要建置步驟、伺服器或套件安裝。

## 部署

**GitHub Pages**：把這個資料夾推送到 GitHub 儲存庫，在儲存庫的 Settings → Pages 選擇部署來源分支與根目錄。

**Netlify**：將此資料夾拖放到 Netlify，或連結 GitHub 儲存庫；發布目錄設為 `.`，不需要建置命令。

## 3D 資產

`assets/dream_key.blend` 和 `assets/dream_key.glb` 是用 Blender 程式化製作的低多邊形夢之鑰匙，可在 Blender 編輯，或匯入 Godot/WebGL 專案作為後續 3D 展示素材。重新產生可執行：

```powershell
C:\blender\blender.exe --background --python tools\make_key.py
```

遊戲本身以原生 HTML/CSS/JavaScript 製作，免除執行 Godot 匯出流程，也能直接部署為靜態網站。
