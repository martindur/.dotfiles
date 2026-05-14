#!/usr/bin/env bash

# Logging helper for linux/arch/setup scripts
# Provides colorful output and log file tracking

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Log file location
INSTALL_LOG_FILE="${INSTALL_LOG_FILE:-/tmp/linux-arch-setup-install.log}"

# Initialize log file
init_log() {
  touch "$INSTALL_LOG_FILE"
  echo "=== Arch Setup Started: $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$INSTALL_LOG_FILE"
  echo ""
}

# Finish log file
finish_log() {
  echo "=== Arch Setup Completed: $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$INSTALL_LOG_FILE"
  echo ""
}

# Log a message to both console and file
log() {
  local message="$1"
  echo -e "${GRAY}[$(date '+%H:%M:%S')]${NC} $message"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$INSTALL_LOG_FILE"
}

# Log info message (green)
log_info() {
  local message="$1"
  echo -e "${GREEN}✓${NC} $message"
  echo "[INFO] $message" >> "$INSTALL_LOG_FILE"
}

# Log warning message (yellow)
log_warn() {
  local message="$1"
  echo -e "${YELLOW}⚠${NC} $message"
  echo "[WARN] $message" >> "$INSTALL_LOG_FILE"
}

# Log error message (red)
log_error() {
  local message="$1"
  echo -e "${RED}✗${NC} $message" >&2
  echo "[ERROR] $message" >> "$INSTALL_LOG_FILE"
}

# Log section header (blue)
log_section() {
  local message="$1"
  echo ""
  echo -e "${BLUE}==>${NC} ${message}"
  echo "" >> "$INSTALL_LOG_FILE"
  echo "=== $message ===" >> "$INSTALL_LOG_FILE"
}

# Run a script and log its output
run_logged() {
  local script="$1"
  local script_name=$(basename "$script")

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script_name" >> "$INSTALL_LOG_FILE"

  if bash "$script" >> "$INSTALL_LOG_FILE" 2>&1; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script_name" >> "$INSTALL_LOG_FILE"
    return 0
  else
    local exit_code=$?
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script_name (exit code: $exit_code)" >> "$INSTALL_LOG_FILE"
    return $exit_code
  fi
}
