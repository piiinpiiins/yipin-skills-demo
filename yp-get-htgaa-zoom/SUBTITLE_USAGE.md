# 字幕檔使用指南

下載的字幕檔（`.srt` 或 `.vtt` 格式）可以用多種方式使用。

## 1. 在影片播放器中使用

### VLC Player（推薦）

**方法 1：自動載入**
- 將字幕檔和影片檔放在同一目錄
- 確保檔名相同（例如：`video.mp4` 和 `video.srt`）
- 開啟影片時會自動載入字幕

**方法 2：手動載入**
1. 開啟 VLC Player
2. 播放影片
3. 點選「字幕」→「加入字幕檔案」
4. 選擇下載的 `.srt` 或 `.vtt` 檔案

### QuickTime Player（macOS）

QuickTime 原生不支援外部字幕，需要：
1. 使用 IINA（免費，推薦）替代
2. 或將字幕嵌入影片（見下方說明）

### IINA（macOS，推薦）

```bash
# 安裝 IINA
brew install iina
```

使用方式：
- 拖放字幕檔到播放視窗
- 或按 `⌘ + S` 選擇字幕檔

### MPC-HC / MPC-BE（Windows）

- 字幕檔與影片同名時自動載入
- 或右鍵點擊播放器 → 字幕 → 載入字幕

### mpv（跨平台）

```bash
# 安裝 mpv
# macOS
brew install mpv

# Linux
sudo apt-get install mpv
```

使用：
```bash
mpv video.mp4 --sub-file=video.srt
```

## 2. 將字幕嵌入影片

使用 ffmpeg 將字幕永久嵌入影片：

### 軟字幕（可開關）

```bash
# 安裝 ffmpeg（如果尚未安裝）
brew install ffmpeg  # macOS
# sudo apt-get install ffmpeg  # Linux

# 將字幕嵌入為軟字幕（可在播放器中開關）
ffmpeg -i input.mp4 -i input.srt -c copy -c:s mov_text output.mp4
```

### 硬字幕（永久燒錄）

```bash
# 將字幕永久燒錄到影片中（無法關閉）
ffmpeg -i input.mp4 -vf "subtitles=input.srt" output.mp4

# 自訂字幕樣式
ffmpeg -i input.mp4 -vf "subtitles=input.srt:force_style='FontName=Arial,FontSize=24,PrimaryColour=&H00FFFFFF,OutlineColour=&H00000000,Outline=2'" output.mp4
```

## 3. 轉換字幕格式

### SRT 轉 VTT

```bash
# 使用 ffmpeg
ffmpeg -i input.srt output.vtt

# 或使用 sed（簡單轉換）
(echo "WEBVTT"; echo ""; cat input.srt) > output.vtt
```

### VTT 轉 SRT

```bash
ffmpeg -i input.vtt output.srt
```

### 轉換為其他格式

使用線上工具或專用軟體：
- [Subtitle Edit](https://www.nikse.dk/subtitleedit/) - 強大的字幕編輯工具
- [Aegisub](http://www.aegisub.org/) - 專業字幕製作工具

## 4. 編輯字幕內容

### 使用文字編輯器

SRT 格式範例：
```srt
1
00:00:00,000 --> 00:00:05,000
這是第一句字幕

2
00:00:05,500 --> 00:00:10,000
這是第二句字幕
```

可以直接用任何文字編輯器修改：
- VS Code
- Sublime Text
- Notepad++

### 使用專業字幕編輯器

**Subtitle Edit**（免費，Windows/Linux/macOS）
```bash
# macOS 使用 Wine 或虛擬機
# Linux
sudo apt-get install subtitleeditor
```

**Aegisub**（免費，跨平台）
```bash
# macOS
brew install aegisub

# Linux
sudo apt-get install aegisub
```

## 5. 翻譯字幕

### 使用線上工具
- Google Translate
- DeepL
- ChatGPT / Claude

### 自動翻譯腳本

使用 Python + Google Translate API：

```python
# translate_srt.py
import srt
from googletrans import Translator

def translate_subtitle(input_file, output_file, target_lang='zh-tw'):
    translator = Translator()

    with open(input_file, 'r', encoding='utf-8') as f:
        subtitles = list(srt.parse(f.read()))

    for sub in subtitles:
        translated = translator.translate(sub.content, dest=target_lang)
        sub.content = translated.text

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(srt.compose(subtitles))

# 使用方式
translate_subtitle('input.srt', 'output_zh.srt', 'zh-tw')
```

## 6. 提取文字內容（做筆記）

### 提取純文字

```bash
# 從 SRT 提取文字（移除時間碼）
grep -v "^[0-9]*$" input.srt | grep -v "^$" | grep -v " --> " > notes.txt

# 或使用 awk
awk '!/^[0-9]+$/ && !/-->/ && !/^$/' input.srt > notes.txt
```

### 轉換為 Markdown 筆記

```bash
#!/bin/bash
# srt_to_markdown.sh

INPUT_SRT="$1"
OUTPUT_MD="$2"

echo "# 課程筆記" > "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"
echo "來源：$INPUT_SRT" >> "$OUTPUT_MD"
echo "" >> "$OUTPUT_MD"

awk '
    /^[0-9]+$/ { num=$0; next }
    /-->/ { time=$0; next }
    /^$/ { next }
    { print "- [" time "] " $0 }
' "$INPUT_SRT" >> "$OUTPUT_MD"
```

使用：
```bash
bash srt_to_markdown.sh input.srt notes.md
```

## 7. 搜尋字幕內容

### 快速搜尋關鍵字

```bash
# 搜尋包含特定關鍵字的字幕段落
grep -A 2 -B 2 "關鍵字" input.srt

# 搜尋並顯示時間碼
grep -B 1 "關鍵字" input.srt | grep --color=never " --> "
```

### 建立索引

```python
#!/usr/bin/env python3
# index_subtitles.py

import srt
import sys

def search_subtitles(srt_file, keyword):
    with open(srt_file, 'r', encoding='utf-8') as f:
        subtitles = list(srt.parse(f.read()))

    results = []
    for sub in subtitles:
        if keyword.lower() in sub.content.lower():
            results.append({
                'index': sub.index,
                'time': str(sub.start),
                'content': sub.content
            })

    return results

if __name__ == '__main__':
    results = search_subtitles(sys.argv[1], sys.argv[2])
    for r in results:
        print(f"[{r['time']}] {r['content']}")
```

使用：
```bash
python index_subtitles.py input.srt "machine learning"
```

## 8. 在網頁中使用（HTML5）

如果你想在網頁上播放影片並顯示字幕：

```html
<!DOCTYPE html>
<html>
<head>
    <title>影片播放</title>
</head>
<body>
    <video width="800" controls>
        <source src="video.mp4" type="video/mp4">
        <track kind="subtitles" src="video.vtt" srclang="en" label="English" default>
        <track kind="subtitles" src="video.zh.vtt" srclang="zh" label="中文">
    </video>
</body>
</html>
```

## 9. 實用工具推薦

### 播放器
- **IINA**（macOS，免費）- 最佳體驗
- **VLC Player**（跨平台，免費）- 功能強大
- **mpv**（跨平台，免費）- 輕量高效

### 字幕編輯
- **Subtitle Edit**（免費）- 功能完整
- **Aegisub**（免費）- 專業級
- **VS Code** + 字幕擴充套件 - 簡單編輯

### 字幕轉換
- **ffmpeg**（命令列，免費）- 萬能轉換
- **HandBrake**（GUI，免費）- 影片+字幕處理

### 線上工具
- [Subtitle Edit Online](https://www.subtitle-edit.com/)
- [Kapwing Subtitle Editor](https://www.kapwing.com/tools/subtitle-editor)
- [Happy Scribe](https://www.happyscribe.com/)

## 10. 常見問題

### Q: 字幕時間不同步怎麼辦？

**使用 Subtitle Edit 調整：**
1. 開啟字幕檔
2. 點選「同步」→「顯示早/晚」
3. 輸入要調整的秒數（正數延後，負數提前）

**使用 ffmpeg：**
```bash
# 延後 2 秒
ffmpeg -itsoffset 2 -i input.srt -c copy output.srt

# 提前 2 秒
ffmpeg -itsoffset -2 -i input.srt -c copy output.srt
```

### Q: 字幕編碼問題（亂碼）？

```bash
# 轉換編碼為 UTF-8
iconv -f BIG5 -t UTF-8 input.srt -o output.srt

# 或使用
file -i input.srt  # 檢查當前編碼
```

### Q: 如何合併多個字幕檔？

```bash
cat part1.srt part2.srt > merged.srt

# 需要重新編號，使用 Subtitle Edit 或腳本
```

### Q: 字幕太快或太慢？

使用 Subtitle Edit:
1. 同步 → 調整速度
2. 輸入影片實際時長
3. 自動調整所有時間碼

## 11. 整合到學習工作流

### 建立課程筆記系統

```bash
#!/bin/bash
# create_course_notes.sh

VIDEO="$1"
SUBTITLE="$2"
OUTPUT_DIR="course_notes"

mkdir -p "$OUTPUT_DIR"

BASENAME=$(basename "$VIDEO" .mp4)

# 1. 提取純文字
awk '!/^[0-9]+$/ && !/-->/ && !/^$/' "$SUBTITLE" > "$OUTPUT_DIR/${BASENAME}_transcript.txt"

# 2. 建立帶時間戳記的筆記
awk '
    /^[0-9]+$/ { next }
    /-->/ { time=$1; next }
    /^$/ { next }
    { print "- [" time "] " $0 }
' "$SUBTITLE" > "$OUTPUT_DIR/${BASENAME}_notes.md"

# 3. 建立索引（關鍵字列表）
grep -i -o "\b[A-Z][a-z]*\b" "$OUTPUT_DIR/${BASENAME}_transcript.txt" | \
    sort | uniq -c | sort -rn > "$OUTPUT_DIR/${BASENAME}_keywords.txt"

echo "課程筆記已建立在 $OUTPUT_DIR/"
```

這樣您就可以充分利用下載的字幕檔了！需要我補充任何其他用途嗎？
