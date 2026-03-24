# Timelapse 4x Movie Generator

快速將影片轉換成 4 倍速縮時攝影，保持原始長寬比例，去除音軌，自動以時間戳記命名。

## 功能特點

- 4x 速度加速影片
- 保持原始長寬比例（不裁切、不變形）
- 移除所有音軌
- 自動命名：`yyyymmdd_HH_MM_SS.mp4`（24 小時制）
- 輸出高品質 H.264 編碼的 MP4 檔案

## 系統需求

必須先安裝 **ffmpeg**：

```bash
# macOS
brew install ffmpeg

# Linux (Ubuntu/Debian)
sudo apt-get install ffmpeg

# Linux (CentOS/RHEL)
sudo yum install ffmpeg
```

## 使用方法

### 基本用法

```bash
bash scripts/process_timelapse.sh <影片路徑>
```

輸出檔案會儲存在與輸入影片相同的目錄。

### 指定輸出目錄

```bash
bash scripts/process_timelapse.sh <影片路徑> <輸出目錄>
```

## 使用範例

### 範例 1：處理單一影片

```bash
bash scripts/process_timelapse.sh ~/Videos/my_video.mp4
```

輸出：`~/Videos/20260316_14_30_55.mp4`

### 範例 2：指定輸出目錄

```bash
bash scripts/process_timelapse.sh ~/Videos/input.mov ~/Desktop/timelapse/
```

輸出：`~/Desktop/timelapse/20260316_14_30_55.mp4`

### 範例 3：批次處理多個影片

```bash
for video in ~/Videos/*.mp4; do
    bash scripts/process_timelapse.sh "$video" ~/Desktop/timelapse_output/
done
```

## 技術細節

### FFmpeg 參數說明

- `-filter:v "setpts=0.25*PTS"` - 將影片速度提升 4 倍
- `-an` - 移除所有音軌
- `-c:v libx264` - 使用 H.264 編碼
- `-preset medium` - 平衡編碼速度與檔案大小
- `-crf 23` - 設定品質（23 為高品質）
- `-movflags +faststart` - 優化串流播放

### 命名格式

輸出檔案使用當前時間戳記命名：
- 格式：`yyyymmdd_HH_MM_SS.mp4`
- 範例：`20260316_14_30_55.mp4`
- 說明：2026 年 3 月 16 日 下午 2:30:55

### 支援的輸入格式

- MP4 (`.mp4`)
- MOV (`.mov`)
- AVI (`.avi`)
- MKV (`.mkv`)
- WebM (`.webm`)
- 以及其他 ffmpeg 支援的影片格式

## 輸出範例

```
=========================================
Timelapse 4x Movie Generator
=========================================
Input video:  /Users/huang/Videos/sample.mp4
Output file:  /Users/huang/Videos/20260316_14_30_55.mp4
Speed:        4x
Audio:        Removed
=========================================

Analyzing input video...
Original duration: 120.00 seconds
New duration:      30.00 seconds (4x speed)

Processing video...
[ffmpeg processing output...]

=========================================
Processing complete!
=========================================
Output saved to: /Users/huang/Videos/20260316_14_30_55.mp4
Input file size:  45M
Output file size: 38M
=========================================
```

## 常見問題

### Q: 影片畫質會下降嗎？
A: 使用 CRF 23 設定可保持高品質。如需更高畫質，可編輯腳本將 `-crf 23` 改為 `-crf 18`（數值越小品質越高，檔案越大）。

### Q: 可以調整速度嗎？
A: 可以。編輯腳本中的 `setpts=0.25*PTS`：
- 2x 速度：`setpts=0.5*PTS`
- 4x 速度：`setpts=0.25*PTS`
- 8x 速度：`setpts=0.125*PTS`

### Q: 如何保留音軌？
A: 移除腳本中的 `-an` 參數，並加入 `-filter:a "atempo=2.0,atempo=2.0"` 來同步加速音軌。

### Q: 輸出檔案很大怎麼辦？
A: 可以調整 CRF 值（增加數字）或改用 `-preset fast` 來減小檔案大小。

## 授權

MIT License
