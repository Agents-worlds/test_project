#!/usr/bin/env bash
set -euo pipefail

REPO="Agents-worlds/test_project"

PLAN_PATH="${PLAN_PATH:-}"
TITLE="${TITLE:-}"
SLUG="${SLUG:-}"

if [ -z "$PLAN_PATH" ]; then
  echo "Error: PLAN_PATH is required." >&2
  exit 1
fi
if [ -z "$TITLE" ]; then
  echo "Error: TITLE is required." >&2
  exit 1
fi
if [ -z "$SLUG" ]; then
  echo "Error: SLUG is required." >&2
  exit 1
fi
if [ ! -f "$PLAN_PATH" ]; then
  echo "Error: PLAN_PATH file not found: $PLAN_PATH" >&2
  exit 1
fi

if [ -f "$HOME/.github_token" ]; then
  # shellcheck disable=SC1090
  source "$HOME/.github_token"
fi

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "Error: GITHUB_TOKEN is missing. Run: source ~/.github_token" >&2
  exit 1
fi

if [ -z "${GH_TOKEN:-}" ]; then
  export GH_TOKEN="$GITHUB_TOKEN"
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh is not installed. Run: bash scripts/gh_install.sh" >&2
  exit 1
fi

gh auth status >/dev/null
gh repo view "$REPO" >/dev/null

issue_payload="$(gh issue create \
  --repo "$REPO" \
  --title "$TITLE" \
  --body-file "$PLAN_PATH" \
  --label opencode \
  --json number,url \
  -q '.number,.url')"

ISSUE_NUM="$(printf '%s\n' "$issue_payload" | sed -n '1p')"
ISSUE_URL="$(printf '%s\n' "$issue_payload" | sed -n '2p')"

if [ -z "$ISSUE_NUM" ] || [ -z "$ISSUE_URL" ]; then
  echo "Error: failed to create issue or parse issue output." >&2
  exit 1
fi

DEFAULT_BRANCH="$(gh repo view "$REPO" --json defaultBranchRef -q .defaultBranchRef.name)"
if [ -z "$DEFAULT_BRANCH" ]; then
  echo "Error: failed to resolve repository default branch." >&2
  exit 1
fi

BRANCH_NAME="issue/${ISSUE_NUM}-${SLUG}"

git fetch origin "$DEFAULT_BRANCH" >/dev/null 2>&1 || true
git checkout -b "$BRANCH_NAME" "origin/$DEFAULT_BRANCH" 2>/dev/null || git checkout -b "$BRANCH_NAME" "$DEFAULT_BRANCH"

git add -u

safe_new_files=()
while IFS= read -r -d '' entry; do
  status="${entry:0:2}"
  path="${entry:3}"
  if [ "$status" = "??" ]; then
    case "$path" in
      .venv/*|.sisyphus/*)
        ;;
      *)
        safe_new_files+=("$path")
        ;;
    esac
  fi
done < <(git status --porcelain -z)

if [ "${#safe_new_files[@]}" -gt 0 ]; then
  git add -- "${safe_new_files[@]}"
fi

if git diff --staged --quiet; then
  echo "Error: no changes to commit for PR." >&2
  exit 1
fi

git commit -m "$TITLE"
git push -u origin "$BRANCH_NAME"

PR_TITLE="${TITLE} (#${ISSUE_NUM})"
PR_URL="$({
  cat <<EOF
Closes #${ISSUE_NUM}
EOF
} | gh pr create \
  --repo "$REPO" \
  --base "$DEFAULT_BRANCH" \
  --head "$BRANCH_NAME" \
  --title "$PR_TITLE" \
  --body-file - \
  --json url \
  -q .url)"

gh pr merge "$PR_URL" --auto --squash --delete-branch >/dev/null

printf '%s\n' "$ISSUE_URL"
printf '%s\n' "$ISSUE_NUM"
printf '%s\n' "$PR_URL"
