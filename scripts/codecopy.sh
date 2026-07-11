#!/usr/bin/env bash

set -euo pipefail

usage() {
	cat <<'EOF'
Usage: codecopy.sh [--dry-run] SOURCE DESTINATION

Sync the contents of SOURCE into DESTINATION using rsync.

Examples:
	codecopy.sh /home/rhuser/github/alta3/mycode /tmp/mycode-backup
	codecopy.sh /tmp/mycode-backup /home/rhuser/github/alta3/mycode
EOF
}

dry_run=0

if [[ "${1:-}" == "--dry-run" ]]; then
	dry_run=1
	shift
fi

if [[ $# -ne 2 ]]; then
	usage >&2
	exit 1
fi

source_path=$(realpath "$1")
destination_path=$(realpath -m "$2")

if [[ ! -d "$source_path" ]]; then
	echo "Source directory does not exist: $source_path" >&2
	exit 1
fi

if [[ "$source_path" == "$destination_path" ]]; then
	echo "Source and destination must be different paths." >&2
	exit 1
fi

mkdir -p "$destination_path"

rsync_args=(-a --delete --info=stats2,progress2)
if [[ "$dry_run" -eq 1 ]]; then
	rsync_args+=(--dry-run)
fi

rsync "${rsync_args[@]}" "$source_path"/ "$destination_path"/
