#!/bin/bash

set -e  # 오류 발생 시 즉시 종료
set -x  # 실행되는 모든 명령어 출력 (디버깅용)

echo "📌 Running Firebase Crashlytics script..." >&2

# Tuist 프로젝트 루트 확인
echo "📂 TUIST_ROOT: $TUIST_ROOT" >&2
echo "📂 PROJECT_DIR: $PROJECT_DIR" >&2
echo "📂 SRCROOT: $SRCROOT" >&2
pwd >&2

# Crashlytics 실행 파일 경로 설정
CRASHLYTICS_SCRIPT="$TUIST_ROOT/Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run"

if [ ! -f "$CRASHLYTICS_SCRIPT" ]; then
  echo "❌ ERROR: Crashlytics script not found at $CRASHLYTICS_SCRIPT" >&2
  exit 1
fi

# 실행
"$CRASHLYTICS_SCRIPT"
