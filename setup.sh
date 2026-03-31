#!/usr/bin/env bash
# Run once after cloning: generates android/, ios/, etc. Requires Flutter SDK on PATH.
set -euo pipefail
cd "$(dirname "$0")"
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter is not on PATH. Install Flutter 3.24+ then re-run: bash setup.sh"
  exit 1
fi
flutter create --org com.morpheumlabs --project-name rainbow_flutter .
echo "Done. Next: flutter pub get && flutter run"
