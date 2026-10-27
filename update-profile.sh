#!/usr/bin/env bash
# Replace the "Custom Dotfiles Integration" block in ~/.profile, or append it if missing.
#
# Usage: update-dotfiles-block.sh [BODY_BLOCK]
#   BODY_BLOCK  optional string whose contents become the block body
#              (defaults to the body defined below)
# Env:   PROFILE_FILE  target file (default: $HOME/.profile)

set -euo pipefail

PROFILE_FILE="${PROFILE_FILE:-$HOME/.profile}"
START_MARKER="# Start Custom Dotfiles Integration"
END_MARKER="# End Custom Dotfiles Integration"

if [[ $# -ge 1 ]]; then
    BLOCK_BODY="$1"
else
    BLOCK_BODY="source \"$HOME/.config/coderv2/dotfiles/home/start.sh\""
fi

touch "$PROFILE_FILE"

has_start=0; has_end=0
grep -qxF "$START_MARKER" "$PROFILE_FILE" && has_start=1
grep -qxF "$END_MARKER" "$PROFILE_FILE" && has_end=1

if (( has_start != has_end )); then
    echo "error: $PROFILE_FILE has an unmatched dotfiles marker; fix it manually" >&2
    exit 1
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

if (( has_start )); then
    # Replace everything between the markers with the new body.
    START_MARKER="$START_MARKER" END_MARKER="$END_MARKER" BLOCK_BODY="$BLOCK_BODY" \
    awk '
        $0 == ENVIRON["START_MARKER"] { print; print ENVIRON["BLOCK_BODY"]; skip = 1; next }
        skip && $0 == ENVIRON["END_MARKER"] { skip = 0; print; next }
        !skip { print }
    ' "$PROFILE_FILE" > "$tmp"
    action="Replaced"
else
    cat "$PROFILE_FILE" > "$tmp"
    if [[ -s "$tmp" ]]; then
        # Ensure a trailing newline, then a blank separator line.
        [[ "$(tail -c1 "$tmp")" == "" ]] || printf '\n' >> "$tmp"
        printf '\n' >> "$tmp"
    fi
    printf '%s\n%s\n%s\n' "$START_MARKER" "$BLOCK_BODY" "$END_MARKER" >> "$tmp"
    action="Added"
fi

# Write back in place to preserve permissions and symlinks.
cat "$tmp" > "$PROFILE_FILE"
echo "$action dotfiles integration block in $PROFILE_FILE"
