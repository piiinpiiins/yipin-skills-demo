# HTGAA Zoom Recording Downloader

## 基本資訊

- **技能名稱**: HTGAA Zoom Recording Downloader
- **類別**: 影片下載工具
- **難度**: 初級
- **標籤**: `zoom`, `video`, `download`, `htgaa`, `automation`

## 描述

自動化下載 HTGAA (How To Grow Almost Anything) 課程的 Zoom meeting 錄影和字幕檔案。此工具能夠：

1. 接收 Zoom 錄影分享連結
2. 自動下載錄影檔案 (MP4 格式)
3. 自動下載字幕檔案 (VTT/SRT 格式，如果有的話)
4. 建立專用資料夾 "htgaa video"
5. 以錄影時間戳記命名檔案 (格式: `yyyymmdd_HHMMSS`)

## 使用場景

- 📚 課程影片管理：整理 HTGAA 或其他線上課程的錄影
- 🎓 學習資料備份：保存重要的教學影片
- 📁 批次下載：一次下載多個課程錄影
- 🔄 自動化工作流：整合到自動化學習資料管理系統

## 核心功能

### 1. 智慧下載
- 自動解析 Zoom 分享頁面
- 提取錄影和字幕下載連結
- 支援大檔案下載（使用 curl 或 wget）

### 2. 自動命名
- 從 Zoom 頁面提取錄影時間
- 轉換為標準格式：`yyyymmdd_HHMMSS`
- 影片和字幕使用相同基礎檔名

### 3. 檔案管理
- 自動建立輸出目錄
- 預設使用 "htgaa video" 資料夾
- 支援自訂輸出路徑

### 4. 錯誤處理
- 檢查必要工具是否安裝
- 驗證下載連結有效性
- 提供詳細的錯誤訊息和警告

## 技術實作

### 依賴工具

#### 方法 1：使用 yt-dlp（推薦）
- `yt-dlp`: 強大的影片下載工具，支援多種網站
- 可從瀏覽器提取 cookies 以處理需要登入的錄影
- 自動下載多語言字幕

#### 方法 2：使用 Shell 腳本
- `curl`: HTTP 請求和檔案下載
- `wget`: 替代下載工具（選用）
- `grep`: 文字搜尋和提取
- `sed`: 文字處理

### 工作流程

#### 方法 1：yt-dlp 工作流程（推薦）
```
使用者輸入 URL
    ↓
從瀏覽器提取 cookies（如需要）
    ↓
yt-dlp 解析 Zoom 頁面
    ↓
獲取影片和字幕 URL
    ↓
建立輸出目錄
    ↓
下載影片和所有字幕
    ↓
轉換字幕格式（VTT → SRT）
    ↓
整理檔案命名
    ↓
顯示完成訊息
```

#### 方法 2：Shell 腳本工作流程
```
使用者輸入 URL
    ↓
獲取 Zoom 頁面內容
    ↓
解析錄影時間和下載連結
    ↓
建立輸出目錄
    ↓
下載影片檔案
    ↓
下載字幕檔案（如果有）
    ↓
顯示完成訊息
```

### 檔案結構

```
yp-get-htgaa-zoom/
├── .gitignore                    # Git 忽略檔案
├── README.md                     # 使用說明
├── SKILL.md                      # 技能描述（本檔案）
├── QUICK_SUBTITLE_GUIDE.md       # 字幕快速使用指南
├── SUBTITLE_USAGE.md             # 字幕詳細使用說明
├── MANUAL_DOWNLOAD_GUIDE.md      # 手動下載指南
├── requirements.txt              # 系統需求
└── scripts/
    ├── download_zoom.sh          # Shell 腳本版本
    └── download_zoom_ytdlp.sh    # yt-dlp 版本（推薦）
```

## 使用範例

### 方法 1：使用 yt-dlp（推薦）

#### 基本使用（公開錄影）

```bash
bash scripts/download_zoom_ytdlp.sh "https://zoom.us/rec/play/xxxxxxxxxxxxx"
```

#### 需要登入的錄影（使用瀏覽器 cookie）

```bash
# 適用於需要 MIT Zoom 帳號登入的錄影
bash scripts/download_zoom_ytdlp.sh "https://mit.zoom.us/rec/play/xxxxxxxxxxxxx"
```

**工作原理：**
- 自動從 Chrome 瀏覽器提取已登入的 cookies
- 使用這些 cookies 來下載需要身份驗證的錄影
- **前提**：你必須先在 Chrome 瀏覽器中登入 MIT Zoom

#### 指定輸出目錄

```bash
bash scripts/download_zoom_ytdlp.sh "https://zoom.us/rec/play/xxxxxxxxxxxxx" "~/Downloads/HTGAA"
```

#### 使用密碼保護的錄影

```bash
bash scripts/download_zoom_ytdlp.sh "https://zoom.us/rec/play/xxxxxxxxxxxxx" "htgaa video" "your_password"
```

### 方法 2：使用 Shell 腳本

#### 基本使用

```bash
bash scripts/download_zoom.sh "https://zoom.us/rec/share/xxxxxxxxxxxxx"
```

#### 指定輸出目錄

```bash
bash scripts/download_zoom.sh "https://zoom.us/rec/share/xxxxxxxxxxxxx" "~/Downloads/HTGAA"
```

### 批次下載

```bash
# 建立 URL 列表
cat > urls.txt << EOF
https://zoom.us/rec/play/url1
https://zoom.us/rec/play/url2
https://zoom.us/rec/play/url3
EOF

# 批次下載
while read url; do
    bash scripts/download_zoom_ytdlp.sh "$url"
    sleep 5  # 避免請求過於頻繁
done < urls.txt
```

## 輸出格式

### 檔案命名
- 影片：`20260203_190057.mp4`
- 主字幕：`20260203_190057.srt`
- 其他字幕：
  - `20260203_190057.cc.srt` (隱藏字幕)
  - `20260203_190057.transcript.srt` (完整轉錄)
  - `20260203_190057.chapter.srt` (章節標記)

### 目錄結構

#### 使用 yt-dlp 的輸出
```
htgaa video/
├── 20260203_190057.mp4              # 影片檔案 (1.5 GB)
├── 20260203_190057.srt              # 主字幕（自動載入）
├── 20260203_190057.cc.srt           # 隱藏字幕版本
├── 20260203_190057.transcript.srt   # 完整轉錄版本
└── 20260203_190057.chapter.srt      # 章節標記
```

**重要特性：**
- ✅ 影片和字幕使用**相同的基礎檔名**
- ✅ 所有檔案都在同一個目錄
- ✅ 大多數播放器會**自動載入** `.srt` 字幕（VLC、IINA、mpv 等）

## 限制與注意事項

### 使用 yt-dlp 方法
1. **存取權限**：
   - 公開錄影：無需登入即可下載
   - 需要登入的錄影：必須先在瀏覽器登入對應帳號（如 MIT Zoom）
   - yt-dlp 會自動從瀏覽器提取 cookies

2. **瀏覽器支援**：
   - 支援 Chrome、Firefox、Edge、Safari 等主流瀏覽器
   - 使用 `--cookies-from-browser chrome` 指定瀏覽器

3. **網路依賴**：需要穩定的網路連線（下載 1.5 GB 約需 1-2 分鐘）

4. **儲存空間**：Zoom 錄影檔案通常很大（1-5 GB），確保有足夠空間

5. **字幕可用性**：
   - yt-dlp 會自動下載所有可用的字幕（transcript、cc、chapter）
   - 自動轉換為 SRT 格式

### 使用 Shell 腳本方法
1. **限制較多**：
   - 不支援需要登入驗證的錄影
   - 不支援密碼保護的錄影
   - 字幕下載可能不穩定

2. **建議**：對於需要登入的錄影，請使用 yt-dlp 方法或參考 [MANUAL_DOWNLOAD_GUIDE.md](MANUAL_DOWNLOAD_GUIDE.md)

## 進階應用

### 整合到自動化工作流

可以與其他工具結合使用：

1. **自動轉檔**：下載後使用 ffmpeg 壓縮
2. **雲端備份**：自動上傳到 Google Drive 或其他雲端服務
3. **字幕處理**：轉換字幕格式或翻譯
4. **通知系統**：下載完成後發送通知

### 範例：下載後自動壓縮

```bash
bash scripts/download_zoom.sh "$ZOOM_URL"
ffmpeg -i "htgaa video/*.mp4" -c:v libx264 -crf 28 -preset fast "compressed/*.mp4"
```

## 擴展建議

未來可以新增的功能：

- [x] 支援需要登入的錄影（使用 yt-dlp + cookies）
- [x] 自動下載多語言字幕
- [x] 字幕格式轉換（VTT → SRT）
- [ ] 自動字幕翻譯
- [ ] 並行下載多個檔案
- [ ] 錄影品質選擇（HD/SD）
- [ ] 自動重試失敗的下載
- [ ] 整合 Zoom API
- [ ] GUI 圖形介面

## 相關技能

- **yp-timelapse_4x_movie_generator**: 影片加速處理
- **yp-short-movie-generator**: 短片製作
- **video-transcription**: 影片字幕轉錄

## 授權

MIT License

## 作者

Created for HTGAA course participants

## 更新歷史

- **v1.1.0** (2026-03-17)
  - ✨ 新增 yt-dlp 下載方法（推薦）
  - ✨ 支援需要登入驗證的 MIT Zoom 錄影
  - ✨ 自動從瀏覽器提取 cookies
  - ✨ 自動下載多語言字幕（transcript、cc、chapter）
  - ✨ 自動轉換字幕格式（VTT → SRT）
  - 📝 新增完整的使用文檔
  - 🔧 改進檔案命名邏輯
  - 🗑️ 清理冗餘檔案，新增 .gitignore

- **v1.0.0** (2026-03-17)
  - 初始版本
  - 支援基本的 Zoom 錄影下載
  - 自動時間戳記命名
  - Shell 腳本下載方法
