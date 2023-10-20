#!/bin/bash
#===============================================================================
#
# Package Lambda code and dependencies as a zip file
#
#===============================================================================

# log prints output to the console with timestamp and nice formatting.
function log() {
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    LIGHT_GREEN='\033[1;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    LIGHT_BLUE='\033[1;34m'
    RESET='\033[0m' # Text reset - no Color
    printf '%.s─' $(seq 1 $(tput cols))
    echo -e "${YELLOW}$(date -u --iso-8601=seconds)${RESET} $@"
    printf '%.s─' $(seq 1 $(tput cols))
}


tmpdir="$(mktemp -d)"
log tmpdir: $tmpdir
#trap 'rm -rf -- "$tmpdir"' EXIT
poetry install
poetry build
#trap 'rm -rf -- ./dist' EXIT
poetry run pip install --upgrade -t "$tmpdir" dist/*.whl
artifact="$(pwd)/artifact.zip"
cd "$tmpdir" && zip -r "$artifact" . -x '*.pyc'