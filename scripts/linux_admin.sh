#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: linux_admin.sh <command>

Commands:
  help           Show this help text
  system-info    Print host, kernel, uptime, and logged-in users
  disk-usage     Show disk usage (human-readable)
  memory-usage   Show memory usage summary
  top-processes  Show top 10 processes by memory usage
EOF
}

system_info() {
  echo "Hostname: $(hostname)"
  echo "Kernel: $(uname -r)"
  echo "Uptime: $(uptime -p)"
  echo "Logged in users:"
  who
}

disk_usage() {
  df -h
}

memory_usage() {
  free -h
}

top_processes() {
  ps aux --sort=-%mem | head -n 11
}

main() {
  local command="${1:-help}"

  case "$command" in
    help|-h|--help)
      usage
      ;;
    system-info)
      system_info
      ;;
    disk-usage)
      disk_usage
      ;;
    memory-usage)
      memory_usage
      ;;
    top-processes)
      top_processes
      ;;
    *)
      echo "Unknown command: $command" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
