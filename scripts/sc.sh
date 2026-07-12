#!/usr/bin/env bash
# sc.sh — Run the source_control.yml Ansible playbook with tag selection and variable overrides.

set -euo pipefail

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYBOOK="${SCRIPT_DIR}/../ansible/playbooks/source_control.yml"

# ---------------------------------------------------------------------------
# Valid tags (order matches typical workflow progression)
# ---------------------------------------------------------------------------
declare -A TAG_DESC=(
    [clone_repo_dir]="Clone repo into parent directory using the repo name derived from repo_url"
    [clone_into_root]="Clone repo directly into repo_dest (dot-clone)"
    [configuration]="Print git config, branch list, remotes, and current branch status"
    [make_branch]="Create a new local branch or switch to an existing one"
    [switch_pull]="Switch to target branch and pull latest changes from remote"
    [switch_stage]="Switch to target branch and stage files_to_stage"
    [commit]="Commit staged changes (prompts for message if commit_message is unset)"
    [push]="Push HEAD to the remote target branch"
)

# Ordered for display purposes
ORDERED_TAGS=(
    clone_repo_dir
    clone_into_root
    configuration
    make_branch
    switch_pull
    switch_stage
    commit
    push
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Run the source_control.yml Ansible playbook with optional tag filtering
and per-run variable overrides.

Options:
  -t <tag>          Run only tasks matching <tag>. Pass -t alone (no argument)
                    to list all valid tags with descriptions.
  -e <key=value>    Set or override an Ansible variable (may be repeated).
                    Example: -e branch_name=feat/my-feature
  -v                Enable verbose Ansible output (-v). Repeat for more verbosity
                    (e.g. -vv, -vvv) — just pass -v multiple times.
  -C                Run in check mode (dry-run); no changes will be made.
  -i <inventory>    Path to an inventory file or host pattern (default: localhost).
  -h                Show this help and exit.

Overridable variables (defaults come from vars/vars.yml):
  repo_url          Git remote URL
  repo_parent_dir   Parent directory for clone_repo_dir workflow
  repo_dest         Destination directory for clone_into_root workflow
  branch_name       Branch to create/switch to/pull/push
  default_branch    Branch used during initial clone
  remote_name       Git remote name (default: origin)
  files_to_stage    Files passed to 'git add' (default: ".")
  commit_message    Commit message; if empty, the playbook will prompt

Examples:
  $(basename "$0") -t clone_repo_dir
  $(basename "$0") -t push -e branch_name=feat/lab24 -e commit_message="My commit"
  $(basename "$0") -t commit -e commit_message="Add playbook"
  $(basename "$0") -t            # lists all valid tags
  $(basename "$0") -h
EOF
}

list_tags() {
    echo "Valid tags for source_control.yml:"
    echo
    local max_len=0
    for tag in "${ORDERED_TAGS[@]}"; do
        (( ${#tag} > max_len )) && max_len=${#tag}
    done
    for tag in "${ORDERED_TAGS[@]}"; do
        printf "  %-*s  %s\n" "$max_len" "$tag" "${TAG_DESC[$tag]}"
    done
}

die() {
    echo "ERROR: $*" >&2
    echo "Run '$(basename "$0") -h' for usage." >&2
    exit 1
}

is_valid_tag() {
    local needle="$1"
    for tag in "${ORDERED_TAGS[@]}"; do
        [[ "$tag" == "$needle" ]] && return 0
    done
    return 1
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
ANSIBLE_TAG=""
EXTRA_VARS=()
VERBOSITY=""
CHECK_MODE=""
INVENTORY=""
TAG_FLAG_SEEN=false

while getopts ":t:e:vCi:h" opt; do
    case "${opt}" in
        t)
            TAG_FLAG_SEEN=true
            ANSIBLE_TAG="${OPTARG}"
            ;;
        e)
            EXTRA_VARS+=("${OPTARG}")
            ;;
        v)
            VERBOSITY="${VERBOSITY}v"
            ;;
        C)
            CHECK_MODE="--check"
            ;;
        i)
            INVENTORY="${OPTARG}"
            ;;
        h)
            usage
            exit 0
            ;;
        :)
            # -t with no argument: list tags and exit
            if [[ "${OPTARG}" == "t" ]]; then
                list_tags
                exit 0
            fi
            die "Option -${OPTARG} requires an argument."
            ;;
        \?)
            die "Unknown option: -${OPTARG}"
            ;;
    esac
done
shift $(( OPTIND - 1 ))

# Extra positional arguments are not accepted
if [[ $# -gt 0 ]]; then
    die "Unexpected arguments: $*"
fi

# ---------------------------------------------------------------------------
# Validate inputs
# ---------------------------------------------------------------------------
if [[ ! -f "${PLAYBOOK}" ]]; then
    die "Playbook not found: ${PLAYBOOK}"
fi

command -v ansible-playbook &>/dev/null || die "'ansible-playbook' not found in PATH."

if [[ -n "${ANSIBLE_TAG}" ]]; then
    is_valid_tag "${ANSIBLE_TAG}" || {
        echo "ERROR: '${ANSIBLE_TAG}' is not a valid tag." >&2
        echo >&2
        list_tags >&2
        echo >&2
        echo "Run '$(basename "$0") -h' for full usage." >&2
        exit 1
    }
fi

# ---------------------------------------------------------------------------
# Build ansible-playbook command
# ---------------------------------------------------------------------------
CMD=(ansible-playbook "${PLAYBOOK}")

if [[ -n "${INVENTORY}" ]]; then
    CMD+=(-i "${INVENTORY}")
else
    CMD+=(-i localhost,)          # comma makes ansible treat it as a host pattern
fi

if [[ -n "${ANSIBLE_TAG}" ]]; then
    CMD+=(--tags "${ANSIBLE_TAG}")
fi

for ev in "${EXTRA_VARS[@]}"; do
    CMD+=(-e "${ev}")
done

if [[ -n "${VERBOSITY}" ]]; then
    CMD+=("-${VERBOSITY}")
fi

if [[ -n "${CHECK_MODE}" ]]; then
    CMD+=("${CHECK_MODE}")
fi

# ---------------------------------------------------------------------------
# Execute
# ---------------------------------------------------------------------------
echo "Running: ${CMD[*]}"
echo

exec "${CMD[@]}"
