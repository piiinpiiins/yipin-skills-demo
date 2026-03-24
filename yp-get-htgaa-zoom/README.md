# HTGAA Zoom Recording Downloader

自動下載 HTGAA (How To Grow Almost Anything) 課程的 Zoom 錄影和字幕檔案。

## 功能特點

- 🎥 自動下載 Zoom meeting 錄影檔
- 📝 自動下載字幕檔（支援多語言）
- 📁 自動建立 "htgaa video" 資料夾
- 🕐 以錄影時間命名檔案（格式：`yyyymmdd_HHMMSS`）
- ✅ 支援 MP4 影片格式
- ✅ 支援 VTT/SRT 字幕格式
- ⚡ 兩種下載方式：yt-dlp（推薦）或純 shell 腳本
- 📖 附字幕使用指南：[快速指南](QUICK_SUBTITLE_GUIDE.md) | [完整教學](SUBTITLE_USAGE.md)

## 系統需求

### 方法 1：使用 yt-dlp（推薦）

推薦使用 `yt-dlp` 進行下載，功能更強大且穩定。

```bash
# macOS
brew install yt-dlp

# Linux (Ubuntu/Debian)
sudo apt-get install python3-pip
pip install yt-dlp

# 或使用 pip
pip install yt-dlp

# 更新 yt-dlp
pip install --upgrade yt-dlp
```

### 方法 2：使用 shell 腳本

僅需安裝基本工具：

- **curl** (必需)
- **wget** (選用，用於下載大檔案)

```bash
# macOS
brew install wget

# Linux (Ubuntu/Debian)
sudo apt-get install wget curl

# Linux (CentOS/RHEL)
sudo yum install wget curl
```

## 使用方法

### 方法 1：使用 yt-dlp（推薦）

**基本用法：**

```bash
bash scripts/download_zoom_ytdlp.sh <zoom_url>
```

**指定輸出目錄：**

```bash
bash scripts/download_zoom_ytdlp.sh <zoom_url> <output_directory>
```

### 方法 2：使用 shell 腳本

**基本用法：**

```bash
bash scripts/download_zoom.sh <zoom_url>
```

**指定輸出目錄：**

```bash
bash scripts/download_zoom.sh <zoom_url> <output_directory>
```

## 使用範例

### 範例 1：下載單一錄影（使用 yt-dlp）

```bash
bash scripts/download_zoom_ytdlp.sh "https://mit.zoom.us/rec/play/xxxxxxxxxxxxx"
```

輸出：
- `htgaa video/20260317_014651.mp4` (影片檔，1.2 GB)
- `htgaa video/20260317_014651.en.srt` (英文字幕，如果有)

### 範例 2：指定輸出目錄

```bash
bash scripts/download_zoom_ytdlp.sh "https://mit.zoom.us/rec/play/xxxxxxxxxxxxx" "~/Downloads/HTGAA"
```

輸出：
- `~/Downloads/HTGAA/20260317_014651.mp4`
- `~/Downloads/HTGAA/20260317_014651.en.srt`

### 範例 3：批次下載多個錄影

建立一個包含所有 URL 的文字檔 `urls.txt`：

```
https://mit.zoom.us/rec/play/url1
https://mit.zoom.us/rec/play/url2
https://mit.zoom.us/rec/play/url3
```

然後執行：

```bash
while read url; do
    bash scripts/download_zoom_ytdlp.sh "$url"
    sleep 5  # 避免請求過於頻繁
done < urls.txt
```

## 檔案命名規則

檔案名稱會根據 Zoom 錄影的時間自動命名：

- 格式：`yyyymmdd_HHMMSS`
- 範例：`20260317_014651.mp4` 和 `20260317_014651.srt`
- 說明：2026 年 3 月 17 日 凌晨 1:46:51

**重要特性：**
- ✅ 影片和字幕檔使用**完全相同**的基礎檔名
- ✅ 都儲存在同一個資料夾 "htgaa video"
- ✅ 大多數播放器會**自動載入**字幕（VLC、IINA、mpv 等）

如果無法從網頁中提取時間，會使用當前下載時間作為檔名。

## 輸出範例

### 使用 yt-dlp 的輸出：

```
[INFO] ===========================================
[INFO] HTGAA Zoom Recording Downloader
[INFO] ===========================================
[INFO] Zoom URL: https://mit.zoom.us/rec/play/xxxxx
[INFO] Output directory: htgaa video
[INFO] ===========================================
[INFO] 正在獲取錄影資訊...
[INFO] 檔案名稱: 20260317_014651
[INFO] 正在下載錄影和字幕...
[zoom] Extracting URL: https://mit.zoom.us/rec/play/xxxxx
[zoom] Downloading play webpage
[zoom] Downloading play info JSON
[info] Downloading 1 format(s): view
[download] Destination: htgaa video/20260317_014651.mp4
[download] 100% of 1.17GiB in 00:00:50 at 23.71MiB/s
[INFO] ===========================================
[INFO] 下載完成！
[INFO] ===========================================
[INFO] 已下載的檔案：
[INFO]   - 20260317_014651.mp4 (1.2G)
[INFO] ===========================================
```

## 注意事項

1. **網址格式**：確保使用完整的 Zoom 錄影分享連結
2. **存取權限**：某些錄影可能需要密碼或登入才能下載
3. **檔案大小**：Zoom 錄影檔案通常較大，請確保有足夠的硬碟空間
4. **下載速度**：下載速度取決於您的網路連線和 Zoom 伺服器
5. **字幕可用性**：並非所有錄影都有字幕檔案

## 常見問題

### Q: 下載失敗怎麼辦？

A: 請檢查：
- URL 是否正確且可存取
- 是否需要登入 Zoom 帳號
- 網路連線是否正常
- 硬碟空間是否足夠

### Q: 如何獲取 Zoom 錄影 URL？

A:
1. 開啟 Zoom 錄影分享郵件或連結
2. 複製完整的 URL（通常是 `https://zoom.us/rec/share/...`）
3. 使用該 URL 執行腳本

### Q: 支援哪些字幕格式？

A: 目前支援：
- VTT (WebVTT)
- SRT (SubRip)

### Q: 字幕檔要如何使用？

A: 下載的字幕檔有多種用途：
1. 在影片播放器中載入（VLC、IINA、mpv 等）
2. 嵌入影片檔案（使用 ffmpeg）
3. 提取文字做筆記
4. 翻譯成其他語言
5. 搜尋特定內容

**📖 完整說明請見：[字幕檔使用指南](SUBTITLE_USAGE.md)**

### Q: 可以下載受密碼保護的錄影嗎？

A: 目前腳本不支援需要密碼的錄影。您可能需要：
1. 在瀏覽器中登入並獲取 cookies
2. 或使用瀏覽器擴充功能下載

## 疑難排解

### curl 相關錯誤

如果遇到 SSL 證書錯誤，可以在腳本中的 curl 命令加上 `-k` 參數（不建議）：

```bash
curl -k -L -o "$VIDEO_FILENAME" "$VIDEO_URL"
```

### 無法提取錄影時間

腳本會自動使用當前時間作為後備方案。您也可以手動編輯檔名。

## 授權

MIT License
