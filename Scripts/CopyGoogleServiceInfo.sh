#!/bin/bash

set -e  # 오류 발생 시 즉시 종료
set -x  # 실행되는 모든 명령어 출력 (디버깅용)

echo "📌 Running GoogleService-Info.plist copy script..."

# CONFIGURATION 값을 기반으로 환경 설정
case "${CONFIGURATION}" in
  "DEV" )
    SOURCE_FILE="$SRCROOT/../../EnvironmentConfigs/Dev/GoogleService-Info.plist"
    ;;
  "STAGE" )
    SOURCE_FILE="$SRCROOT/../../EnvironmentConfigs/Stage/GoogleService-Info.plist"
    ;;
  "PROD" )
    SOURCE_FILE="$SRCROOT/../../EnvironmentConfigs/Prod/GoogleService-Info.plist"
    ;;
  *)
    echo "⚠️ Warning: No matching configuration for ${CONFIGURATION}. Skipping plist copy."
    exit 0
    ;;
esac

# 목적지 파일 경로 설정
DEST_FILE="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

# 원본 파일이 존재하는지 확인
if [ ! -f "$SOURCE_FILE" ]; then
  echo "❌ ERROR: Source file not found: $SOURCE_FILE"
  exit 1
fi

# 기존 파일과 비교 후 변경이 있는 경우만 복사 (불필요한 복사 방지)
if [ -f "$DEST_FILE" ] && cmp -s "$SOURCE_FILE" "$DEST_FILE"; then
  echo "✅ GoogleService-Info.plist is up to date. No need to copy."
else
  echo "🔄 Copying GoogleService-Info.plist..."
  echo "   📍 Source: $SOURCE_FILE"
  echo "   📍 Destination: $DEST_FILE"
  cp "$SOURCE_FILE" "$DEST_FILE"
  echo "✅ Successfully copied GoogleService-Info.plist."
fi
