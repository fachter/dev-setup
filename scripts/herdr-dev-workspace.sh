#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: herdr-dev-workspace.sh <resolved_dir> <label> [--fresh]" >&2
  exit 1
}

[[ $# -ge 2 ]] || usage

resolved_dir="$1"
label="$2"
fresh=0
shift 2

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fresh)
      fresh=1
      ;;
    *)
      usage
      ;;
  esac
  shift
done

if ! command -v herdr >/dev/null 2>&1; then
  echo "Error: herdr is not installed. See https://herdr.dev/" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required" >&2
  exit 1
fi

if [[ ! -d "$resolved_dir" ]]; then
  echo "Error: Directory '$resolved_dir' not found" >&2
  exit 1
fi

herdr_server_running() {
  herdr status server 2>/dev/null | grep -q 'status: running'
}

ensure_herdr_server() {
  if herdr_server_running; then
    return 0
  fi

  herdr server >/dev/null 2>&1 &
  local attempt
  for attempt in {1..20}; do
    if herdr_server_running; then
      return 0
    fi
    sleep 0.25
  done

  echo "Error: Could not start herdr server" >&2
  return 1
}

find_workspace_by_cwd() {
  local target_cwd="$1"
  local workspace_ids workspace_id pane_cwd

  workspace_ids=$(herdr workspace list | jq -r '.result.workspaces[]?.workspace_id // empty')
  for workspace_id in $workspace_ids; do
    pane_cwd=$(herdr pane list --workspace "$workspace_id" | jq -r '.result.panes[0].cwd // empty')
    if [[ "$pane_cwd" == "$target_cwd" ]]; then
      echo "$workspace_id"
      return 0
    fi
  done
}

ensure_herdr_server

workspace_id=""
if [[ "$fresh" -eq 0 ]]; then
  workspace_id="$(find_workspace_by_cwd "$resolved_dir" || true)"
fi

if [[ -n "$workspace_id" ]]; then
  herdr workspace focus "$workspace_id" >/dev/null
  exit 0
fi

if [[ "$fresh" -eq 1 ]]; then
  label="${label}-fresh-$(date +%H%M%S)"
fi

create_resp="$(herdr workspace create --cwd "$resolved_dir" --label "$label" --no-focus)"
workspace_id="$(echo "$create_resp" | jq -r '.result.workspace.workspace_id // empty')"
nvim_tab_id="$(echo "$create_resp" | jq -r '.result.tab.tab_id // empty')"
nvim_pane_id="$(echo "$create_resp" | jq -r '.result.root_pane.pane_id // empty')"

if [[ -z "$workspace_id" || -z "$nvim_tab_id" || -z "$nvim_pane_id" ]]; then
  echo "Error: Failed to create workspace" >&2
  echo "$create_resp" >&2
  exit 1
fi

herdr tab rename "$nvim_tab_id" "Neovim" >/dev/null
herdr pane run "$nvim_pane_id" nvim >/dev/null

agent_resp="$(herdr tab create --workspace "$workspace_id" --label "Agent" --cwd "$resolved_dir" --no-focus)"
agent_pane_id="$(echo "$agent_resp" | jq -r '.result.root_pane.pane_id // empty')"

if [[ -z "$agent_pane_id" ]]; then
  echo "Error: Failed to create Agent tab" >&2
  echo "$agent_resp" >&2
  exit 1
fi

herdr pane run "$agent_pane_id" agent >/dev/null

herdr tab create --workspace "$workspace_id" --label "Terminal" --cwd "$resolved_dir" --no-focus >/dev/null
herdr tab create --workspace "$workspace_id" --label "Terminal" --cwd "$resolved_dir" --no-focus >/dev/null

herdr tab focus "$nvim_tab_id" >/dev/null
herdr workspace focus "$workspace_id" >/dev/null
