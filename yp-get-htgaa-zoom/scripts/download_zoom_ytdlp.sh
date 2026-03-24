#!/bin/bash

# HTGAA Zoom Recording Downloader (using yt-dlp)
# Downloads Zoom meeting recordings and subtitles

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if URL is provided
if [ -z "$1" ]; then
    print_error "請提供 Zoom 錄影網址"
    echo "使用方法: bash scripts/download_zoom_ytdlp.sh <zoom_url> [output_dir] [password]"
    echo "範例: bash scripts/download_zoom_ytdlp.sh <url> 'htgaa video' htgaa2026!"
    exit 1
fi

ZOOM_URL="$1"
OUTPUT_DIR="${2:-htgaa video}"
ZOOM_PASSWORD="${3:-}"

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    print_error "yt-dlp 未安裝"
    print_info "請使用以下命令安裝："
    print_info "  macOS:  brew install yt-dlp"
    print_info "  Linux:  pip install yt-dlp"
    print_info "  或訪問: https://github.com/yt-dlp/yt-dlp"
    exit 1
fi

print_info "==========================================="
print_info "HTGAA Zoom Recording Downloader"
print_info "==========================================="
print_info "Zoom URL: $ZOOM_URL"
print_info "Output directory: $OUTPUT_DIR"
print_info "==========================================="

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Extract upload date/time to use as filename
print_info "正在獲取錄影資訊..."

# Get video info in JSON format
VIDEO_INFO=$(yt-dlp --dump-json "$ZOOM_URL" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$VIDEO_INFO" ]; then
    print_warning "無法獲取錄影資訊，使用當前時間作為檔名"
    FILENAME=$(date +"%Y%m%d_%H%M%S")
else
    # Try to extract timestamp from JSON
    TIMESTAMP=$(echo "$VIDEO_INFO" | grep -oP '"timestamp":\s*\K[0-9]+' | head -n 1)

    if [ -n "$TIMESTAMP" ]; then
        # Convert Unix timestamp to yyyymmdd_HHMMSS format
        FILENAME=$(date -r "$TIMESTAMP" +"%Y%m%d_%H%M%S" 2>/dev/null)
        if [ -z "$FILENAME" ]; then
            # Fallback for systems without -r option (like some Linux)
            FILENAME=$(date -d "@$TIMESTAMP" +"%Y%m%d_%H%M%S" 2>/dev/null)
        fi
    fi

    # If still no filename, use current time
    if [ -z "$FILENAME" ]; then
        FILENAME=$(date +"%Y%m%d_%H%M%S")
    fi
fi

print_info "檔案名稱: $FILENAME"

# Download video and subtitles
OUTPUT_TEMPLATE="${OUTPUT_DIR}/${FILENAME}.%(ext)s"

print_info "正在下載錄影和字幕..."

# Build yt-dlp command with optional password
YTDLP_CMD="yt-dlp --output \"$OUTPUT_TEMPLATE\" --write-subs --write-auto-subs --sub-langs all --convert-subs srt --format best"

if [ -n "$ZOOM_PASSWORD" ]; then
    print_info "使用密碼下載..."
    YTDLP_CMD="$YTDLP_CMD --video-password \"$ZOOM_PASSWORD\""
fi

YTDLP_CMD="$YTDLP_CMD \"$ZOOM_URL\""

eval $YTDLP_CMD

# Rename subtitle files to match video filename exactly (remove language code)
# This ensures video and subtitle have the same base filename
# e.g., 20260317_014651.en.srt -> 20260317_014651.srt
# e.g., 20260317_014651.transcript.srt -> 20260317_014651.srt
print_info "正在整理字幕檔案名稱..."
shopt -s nullglob
subtitle_count=0
for subtitle in "${OUTPUT_DIR}/${FILENAME}."*.srt; do
    if [ -f "$subtitle" ]; then
        subtitle_basename=$(basename "$subtitle")
        # Extract language/type code (e.g., .en, .zh-TW, .transcript, .cc)
        lang=$(echo "$subtitle_basename" | sed "s/^${FILENAME}\.//;s/\.srt$//")

        if [ -n "$lang" ]; then
            # First subtitle becomes the main one (without language suffix)
            if [ $subtitle_count -eq 0 ]; then
                new_subtitle="${OUTPUT_DIR}/${FILENAME}.srt"
                print_info "  主字幕: $(basename "$subtitle") -> $(basename "$new_subtitle")"
            else
                # Additional subtitles keep their language suffix
                new_subtitle="${OUTPUT_DIR}/${FILENAME}_${lang}.srt"
                print_info "  副字幕: $(basename "$subtitle") -> $(basename "$new_subtitle")"
            fi
            mv "$subtitle" "$new_subtitle" 2>/dev/null
            subtitle_count=$((subtitle_count + 1))
        fi
    fi
done
shopt -u nullglob

if [ $subtitle_count -eq 0 ]; then
    print_warning "未找到字幕檔案"
fi

if [ $? -eq 0 ]; then
    print_info "==========================================="
    print_info "下載完成！"
    print_info "==========================================="

    # List downloaded files
    print_info "已下載的檔案："
    ls -lh "${OUTPUT_DIR}/${FILENAME}."* 2>/dev/null | while read -r line; do
        filename=$(echo "$line" | awk '{print $NF}')
        filesize=$(echo "$line" | awk '{print $5}')
        print_info "  - $(basename "$filename") ($filesize)"
    done

    print_info "==========================================="
else
    print_error "下載失敗"
    print_info "可能的原因："
    print_info "  1. 需要登入 Zoom 帳號"
    print_info "  2. 錄影已被刪除或過期"
    print_info "  3. 需要密碼存取"
    print_info "  4. 網路連線問題"
    exit 1
fi
