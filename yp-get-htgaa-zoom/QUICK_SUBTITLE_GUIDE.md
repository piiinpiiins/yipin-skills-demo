# 字幕檔快速使用指南

下載字幕後最常用的 5 種方式：

## 🎬 1. 在影片播放器中使用

### IINA（macOS，推薦）
```bash
# 安裝
brew install iina

# 使用：直接拖放字幕檔到播放視窗，或按 ⌘+S 選擇字幕
```

### VLC Player（跨平台）
```bash
# macOS
brew install vlc

# 使用：字幕 → 加入字幕檔案
# 或將字幕檔和影片檔放同一目錄，確保檔名相同
```

## 📝 2. 提取文字做筆記

```bash
# 快速提取純文字（移除時間碼）
grep -v "^[0-9]*$" input.srt | grep -v "^$" | grep -v " --> " > notes.txt

# 或使用 awk（更乾淨）
awk '!/^[0-9]+$/ && !/-->/ && !/^$/' input.srt > notes.txt
```

## 🔍 3. 搜尋關鍵字

```bash
# 搜尋包含特定關鍵字的段落
grep -A 2 -B 2 "machine learning" input.srt

# 只顯示時間碼
grep -B 1 "machine learning" input.srt | grep " --> "
```

## 🎥 4. 嵌入影片（軟字幕）

```bash
# 安裝 ffmpeg
brew install ffmpeg  # macOS

# 嵌入字幕（可在播放器開關）
ffmpeg -i video.mp4 -i subtitle.srt -c copy -c:s mov_text output.mp4
```

## 🌐 5. 翻譯字幕

### 方法 1：使用 ChatGPT/Claude
1. 複製字幕內容
2. 提示詞：「請將以下 SRT 字幕翻譯成繁體中文，保持格式不變：」
3. 貼上內容

### 方法 2：使用線上工具
- [DeepL](https://www.deepl.com/) - 高品質翻譯
- [Google Translate](https://translate.google.com/)

---

## 🔗 更多進階用途

完整說明請參考：[SUBTITLE_USAGE.md](SUBTITLE_USAGE.md)

包含：
- 硬字幕燒錄
- 字幕編輯工具
- 格式轉換
- 時間同步調整
- 建立課程筆記系統
- 更多...
