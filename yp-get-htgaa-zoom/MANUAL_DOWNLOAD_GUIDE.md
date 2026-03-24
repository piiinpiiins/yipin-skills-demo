# 手動下載 MIT Zoom 錄影指南

當自動下載腳本無法運作時（例如需要登入驗證），可以使用以下方法手動下載。

## 方法 1：直接在瀏覽器下載（推薦）

1. **登入 MIT Zoom**
   - 開啟連結：https://mit.zoom.us/
   - 使用你的 MIT 帳號登入

2. **訪問錄影頁面**
   - 貼上你的 Zoom 錄影分享連結
   - 等待頁面載入

3. **下載檔案**
   - 點擊「下載」按鈕下載影片（MP4）
   - 如果有字幕，也點擊下載字幕檔案（SRT/VTT）

4. **整理檔案**
   ```bash
   # 建立目標資料夾
   mkdir -p "htgaa video"

   # 移動並重新命名檔案（使用錄影時間）
   # 格式：yyyymmdd_HHMMSS
   mv ~/Downloads/video.mp4 "htgaa video/20260317_140000.mp4"
   mv ~/Downloads/subtitle.srt "htgaa video/20260317_140000.srt"
   ```

## 方法 2：使用開發者工具獲取直接下載連結

如果你想要自動化下載，可以嘗試擷取真實的下載 URL：

1. **開啟開發者工具**
   - 在瀏覽器中按 `F12` 或 `⌘+Option+I`（macOS）
   - 切換到「Network」（網路）分頁
   - 勾選「Preserve log」

2. **開始錄製並下載**
   - 在 Zoom 頁面點擊「下載」按鈕
   - 在 Network 分頁中找到 `.mp4` 檔案
   - 右鍵點擊 → Copy → Copy URL

3. **使用 URL 下載**
   ```bash
   # 使用獲取的 URL 下載（需要替換成真實的 URL）
   curl -L -o "htgaa video/20260317_140000.mp4" "https://zoom.us/rec/download/xxxxx"

   # 如果需要 cookie 認證
   curl -L -b "cookies.txt" -o "htgaa video/20260317_140000.mp4" "https://zoom.us/rec/download/xxxxx"
   ```

4. **匯出瀏覽器 Cookies（如需要）**

   使用瀏覽器擴充功能匯出 cookies：
   - Chrome: [Get cookies.txt](https://chrome.google.com/webstore/detail/get-cookiestxt/bgaddhkoddajcdgocldbbfleckgcbcid)
   - Firefox: [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/)

## 方法 3：使用 yt-dlp 配合登入資訊

如果你有 Zoom 帳號的 cookie 資訊：

```bash
# 使用瀏覽器 cookie
yt-dlp --cookies-from-browser chrome "https://mit.zoom.us/rec/play/xxxxx"

# 或使用 cookie 檔案
yt-dlp --cookies cookies.txt "https://mit.zoom.us/rec/play/xxxxx"
```

## 檔案命名規則

下載後請按以下格式命名：

**格式**：`yyyymmdd_HHMMSS.ext`

**範例**：
- 影片：`20260317_140000.mp4`
- 字幕：`20260317_140000.srt`

**如何找到錄影時間**：
1. 在 Zoom 頁面查看「Meeting Time」或「錄影時間」
2. 轉換為檔名格式：
   - 2026年3月17日 下午2:00:00 → `20260317_140000`

## 常見問題

### Q: 下載的影片沒有字幕怎麼辦？

A: 如果 Zoom 沒有提供字幕檔案下載，可以：
1. 使用 AI 轉錄工具生成字幕（如 Whisper）
2. 使用 YouTube 自動生成字幕後下載

### Q: 下載速度很慢？

A:
1. 確認網路連線穩定
2. 嘗試使用下載管理器（如 aria2）
3. 選擇非尖峰時段下載

### Q: 需要密碼的錄影如何下載？

A:
1. 在瀏覽器中輸入密碼後下載
2. 如果使用腳本，需要先在瀏覽器登入並獲取認證 cookie

## 自動化建議

如果經常需要下載 MIT Zoom 錄影，建議：

1. **使用 cookie 認證**
   ```bash
   # 先在瀏覽器登入 MIT Zoom
   # 使用瀏覽器擴充功能匯出 cookies
   # 使用 yt-dlp 配合 cookies 下載
   yt-dlp --cookies-from-browser chrome <zoom_url>
   ```

2. **建立別名簡化操作**
   ```bash
   # 加入到 ~/.bashrc 或 ~/.zshrc
   alias zoom-dl='yt-dlp --cookies-from-browser chrome --output "htgaa video/%(upload_date)s_%(timestamp)s.%(ext)s"'

   # 使用
   zoom-dl "https://mit.zoom.us/rec/play/xxxxx"
   ```

## 相關資源

- [yt-dlp 文檔](https://github.com/yt-dlp/yt-dlp)
- [Zoom 錄影說明](https://support.zoom.us/hc/en-us/articles/205347605)
- [字幕使用指南](QUICK_SUBTITLE_GUIDE.md)
