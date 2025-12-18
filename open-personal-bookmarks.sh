#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OPEN_SCRIPT="$SCRIPT_DIR/open-personal-bookmarks.py"
CLOSE_SCRIPT="$SCRIPT_DIR/close-personal-bookmarks.py"

case "$1" in
  open)
		/Applications/iTerm.app/Contents/Resources/it2_api_wrapper.sh /usr/bin/python3 "$OPEN_SCRIPT"
    ;;
  close)
		/Applications/iTerm.app/Contents/Resources/it2_api_wrapper.sh /usr/bin/python3 "$CLOSE_SCRIPT"
    ;;
  *)
		echo "Usage: $0 {open|close} (default: open)"
		/Applications/iTerm.app/Contents/Resources/it2_api_wrapper.sh /usr/bin/python3 "$OPEN_SCRIPT"
    exit 1
    ;;
esac


