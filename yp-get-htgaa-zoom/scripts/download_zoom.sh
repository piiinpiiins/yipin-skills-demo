#!/bin/bash

# HTGAA Zoom Recording Downloader
# Downloads Zoom meeting recordings and subtitles

set -e

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
    echo "使用方法: bash scripts/download_zoom.sh <zoom_url> [output_dir]"
    exit 1
fi

ZOOM_URL="$1"
OUTPUT_DIR="${2:-htgaa video}"

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    print_error "curl 未安裝，請先安裝 curl"
    exit 1
fi

# Check if wget is installed (optional, for downloading files)
if ! command -v wget &> /dev/null; then
    print_warning "wget 未安裝，將使用 curl 下載檔案"
    USE_CURL=1
else
    USE_CURL=0
fi

print_info "==========================================="
print_info "HTGAA Zoom Recording Downloader"
print_info "==========================================="
print_info "Zoom URL: $ZOOM_URL"
print_info "Output directory: $OUTPUT_DIR"
print_info "==========================================="

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Fetch the Zoom page to extract recording links
print_info "正在獲取錄影資訊..."

# Download the page HTML
PAGE_HTML=$(curl -s "$ZOOM_URL")

# Extract recording date/time from the page
# This will need to be adjusted based on actual Zoom page structure
MEETING_TIME=$(echo "$PAGE_HTML" | grep -oP 'Meeting Time:.*?</div>' | sed 's/<[^>]*>//g' | sed 's/Meeting Time: //' | head -n 1)

if [ -z "$MEETING_TIME" ]; then
    # Try alternative pattern
    MEETING_TIME=$(echo "$PAGE_HTML" | grep -oP 'topic.*?"[^"]*"' | sed 's/.*"//;s/"$//' | head -n 1)
fi

if [ -z "$MEETING_TIME" ]; then
    print_warning "無法自動偵測錄影時間，使用當前時間"
    MEETING_TIME=$(date +"%Y%m%d_%H%M%S")
else
    # Convert meeting time to filename format (yyyymmdd_HHMMSS)
    # This conversion will depend on the actual format from Zoom
    MEETING_TIME=$(echo "$MEETING_TIME" | sed 's/[^0-9]//g' | head -c 14)
fi

print_info "錄影時間: $MEETING_TIME"

# Extract video download link
VIDEO_URL=$(echo "$PAGE_HTML" | grep -oP 'https://[^"]*\.mp4[^"]*' | head -n 1)

if [ -z "$VIDEO_URL" ]; then
    print_error "無法找到錄影下載連結"
    print_info "請確認 URL 是否正確，或嘗試手動下載"
    exit 1
fi

print_info "找到錄影檔案: $VIDEO_URL"

# Extract subtitle download link (VTT or SRT format)
SUBTITLE_URL=$(echo "$PAGE_HTML" | grep -oP 'https://[^"]*\.(vtt|srt)[^"]*' | head -n 1)

if [ -n "$SUBTITLE_URL" ]; then
    print_info "找到字幕檔案: $SUBTITLE_URL"
else
    print_warning "未找到字幕檔案"
fi

# Download video
VIDEO_FILENAME="${OUTPUT_DIR}/${MEETING_TIME}.mp4"
print_info "正在下載錄影檔案至: $VIDEO_FILENAME"

if [ $USE_CURL -eq 1 ]; then
    curl -L -o "$VIDEO_FILENAME" "$VIDEO_URL"
else
    wget -O "$VIDEO_FILENAME" "$VIDEO_URL"
fi

if [ $? -eq 0 ]; then
    print_info "✓ 錄影檔案下載完成"
    VIDEO_SIZE=$(du -h "$VIDEO_FILENAME" | cut -f1)
    print_info "檔案大小: $VIDEO_SIZE"
else
    print_error "錄影檔案下載失敗"
    exit 1
fi

# Download subtitle if available
if [ -n "$SUBTITLE_URL" ]; then
    SUBTITLE_EXT="${SUBTITLE_URL##*.}"
    SUBTITLE_EXT=$(echo "$SUBTITLE_EXT" | cut -d'?' -f1)
    SUBTITLE_FILENAME="${OUTPUT_DIR}/${MEETING_TIME}.${SUBTITLE_EXT}"

    print_info "正在下載字幕檔案至: $SUBTITLE_FILENAME"

    if [ $USE_CURL -eq 1 ]; then
        curl -L -o "$SUBTITLE_FILENAME" "$SUBTITLE_URL"
    else
        wget -O "$SUBTITLE_FILENAME" "$SUBTITLE_URL"
    fi

    if [ $? -eq 0 ]; then
        print_info "✓ 字幕檔案下載完成"
    else
        print_warning "字幕檔案下載失敗"
    fi
fi

print_info "==========================================="
print_info "下載完成！"
print_info "==========================================="
print_info "錄影檔案: $VIDEO_FILENAME"
if [ -n "$SUBTITLE_URL" ]; then
    print_info "字幕檔案: $SUBTITLE_FILENAME"
fi
print_info "==========================================="
