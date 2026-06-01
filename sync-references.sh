#!/usr/bin/env bash
# Copy the canonical pinocchio_blacklist.md (single source of truth at repo root)
# into each skill's references/ directory. Claude Code skills can only load files
# inside their own directory, so the shared reference must be duplicated per skill
# at packaging time. Edit the root file, then run this to propagate.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/pinocchio_blacklist.md"
SKILLS_DIR="$ROOT/plugins/explainer/skills"

[ -f "$SRC" ] || { echo "error: canonical source not found: $SRC" >&2; exit 1; }
[ -d "$SKILLS_DIR" ] || { echo "error: skills dir not found: $SKILLS_DIR" >&2; exit 1; }

count=0
for skill in "$SKILLS_DIR"/*/; do
  [ -f "$skill/SKILL.md" ] || continue
  ref_dir="${skill}references"
  mkdir -p "$ref_dir"
  cp "$SRC" "$ref_dir/pinocchio_blacklist.md"
  echo "synced -> ${ref_dir}/pinocchio_blacklist.md"
  count=$((count + 1))
done

echo "done: $count skill(s) synced"
