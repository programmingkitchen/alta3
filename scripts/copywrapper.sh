#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

source_path="/home/student/mycode"
destination_path="/home/student/alta3/mycode"

exec "$script_dir/codecopy.sh" "$source_path" "$destination_path" "$@"
