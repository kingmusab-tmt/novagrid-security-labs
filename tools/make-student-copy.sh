#!/usr/bin/env bash
# Build a student-facing copy of the labs from the instructor master.
# Strips: answer-key.md, example-deliverable.md, the Ep11 generator, and tools/.
# Optionally injects a unique Ep11 phishing sample for a named student.
#
# Usage:
#   tools/make-student-copy.sh [--student "Jane Doe"] [--out DIR] [--init]
#
#   --student NAME   generate that student's unique Ep11 sample (no answer sheet)
#   --out DIR        output dir (default: student-build/<student-slug|student>)
#   --init           git init + first commit in the output (ready to push)
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.." && pwd)"
STUDENT=""; OUT=""; INIT=0
while [ $# -gt 0 ]; do
  case "$1" in
    --student) STUDENT="${2:-}"; shift 2;;
    --out)     OUT="${2:-}"; shift 2;;
    --init)    INIT=1; shift;;
    *) echo "unknown arg: $1" >&2; exit 2;;
  esac
done

slug() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]\+/-/g; s/^-//; s/-$//'; }
SLUG="student"; [ -n "$STUDENT" ] && SLUG="$(slug "$STUDENT")"
[ -z "$OUT" ] && OUT="$SRC/student-build/$SLUG"

PY="$(command -v python3 || command -v python || true)"

echo "Building student copy -> $OUT"
rm -rf "$OUT"; mkdir -p "$OUT"

# 1) Clean export of tracked files (no .git, no gitignored/untracked)
git -C "$SRC" archive --format=tar HEAD | tar -x -C "$OUT"

# 2) Strip instructor-only material
find "$OUT" -type f -name 'answer-key.md' -delete
find "$OUT" -type f -name 'example-deliverable.md' -delete
rm -rf "$OUT/ep11-phishing-cfo/generator" "$OUT/tools"

# 3) Per-student unique Ep11 sample (optional)
if [ -n "$STUDENT" ]; then
  if [ -z "$PY" ]; then echo "WARN: python not found; keeping canonical Ep11 sample"; else
    TMP="$(mktemp -d)"
    "$PY" "$SRC/ep11-phishing-cfo/generator/generate_sample.py" --student "$STUDENT" --out "$TMP" >/dev/null
    DATA="$OUT/ep11-phishing-cfo/environment/data"
    rm -f "$DATA"/*.eml "$DATA"/*.html
    cp "$TMP/$SLUG/data/"* "$DATA"/            # eml + attachment only
    rm -f "$DATA/_instructor_answers.md" 2>/dev/null || true
    rm -rf "$TMP"
    echo "  injected unique Ep11 sample for: $STUDENT"
  fi
fi

# 4) Student-facing note
cat > "$OUT/STUDENT.md" <<'TXT'
# Your NovaGrid Security Labs

This is your working copy. Each episode folder has the lab, the environment setup, a
deliverable template to fill in, and a rubric. Do the work, drop your screenshots/exports
into each episode's `evidence/` folder, and fill the report template — that becomes your
portfolio. Answer keys are not included (ask your instructor if you're stuck).
TXT

echo "Done. Episodes in the student copy:"
ls -d "$OUT"/ep*/ 2>/dev/null | sed 's|.*/\(ep[^/]*\)/|  \1|'

# 5) Optional: make it a ready-to-push repo
if [ "$INIT" -eq 1 ]; then
  ( cd "$OUT" && git init -q -b main && git add -A && \
    git -c user.name="NovaGrid Labs" -c user.email="labs@example.com" commit -q -m "Student copy of NovaGrid Security Labs" )
  echo "  git repo initialised in $OUT"
fi
