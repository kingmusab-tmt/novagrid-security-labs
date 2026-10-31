#!/usr/bin/env bash
# Build — or UPDATE — a student-facing copy of the labs from the instructor master.
# Strips: answer-key.md, example-deliverable.md, every episode generator, _instructor_answers.*,
# and tools/. Swaps in the portfolio case-file README (episode index becomes EPISODES.md).
#
# Usage:
#   tools/make-student-copy.sh [--student "Jane Doe"] [--out DIR] [--init]
#   tools/make-student-copy.sh --update DIR
#
#   --student NAME   generate that student's unique Ep11 sample (no answer sheet)
#   --out DIR        output dir (default: student-build/<student-slug|student>)
#   --init           git init + first commit in the output (a fresh, ready-to-push repo)
#   --update DIR     refresh an EXISTING student repo in place: overwrite the instructor
#                    content, keep its .git history and every student file (evidence/, report.md),
#                    then commit — so forks can sync with `git pull`. Does NOT re-init.
#
# Pick ONE of --init / --update. Use --init once to create the canonical student repo; use
# --update every time after that to publish changes to it (so student forks stay syncable —
# a fresh --init would break their history).
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.." && pwd)"
STUDENT=""; OUT=""; INIT=0; UPDATE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --student) STUDENT="${2:-}"; shift 2;;
    --out)     OUT="${2:-}"; shift 2;;
    --init)    INIT=1; shift;;
    --update)  UPDATE="${2:-}"; shift 2;;
    *) echo "unknown arg: $1" >&2; exit 2;;
  esac
done

slug() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]\+/-/g; s/^-//; s/-$//'; }
PY="$(command -v python3 || command -v python || true)"

# Apply the sanitize + packaging steps to a directory that already holds a fresh export.
sanitize_and_package() {
  local OUT="$1" STUDENT="$2"
  # 1) Strip instructor-only material
  find "$OUT" -type f -name 'answer-key.md' -delete
  find "$OUT" -type f -name 'example-deliverable.md' -delete
  rm -rf "$OUT/tools"
  find "$OUT" -type d -name generator -prune -exec rm -rf {} +
  find "$OUT" -type f -name "_instructor_answers.*" -delete

  # 2) Per-student unique Ep11 sample (build mode only)
  if [ -n "$STUDENT" ]; then
    if [ -z "$PY" ]; then echo "WARN: python not found; keeping canonical Ep11 sample"; else
      local TMP; TMP="$(mktemp -d)"
      "$PY" "$SRC/ep11-phishing-cfo/generator/generate_sample.py" --student "$STUDENT" --out "$TMP" >/dev/null
      local DATA="$OUT/ep11-phishing-cfo/environment/data"
      rm -f "$DATA"/*.eml "$DATA"/*.html
      cp "$TMP/$(slug "$STUDENT")/data/"* "$DATA"/
      rm -f "$DATA/_instructor_answers.md" 2>/dev/null || true
      rm -rf "$TMP"
      echo "  injected unique Ep11 sample for: $STUDENT"
    fi
  fi

  # 3) Portfolio front page: the case-file template becomes README.md; index -> EPISODES.md
  mv -f "$OUT/README.md" "$OUT/EPISODES.md"
  cp "$SRC/docs/portfolio/CASEFILE-README-TEMPLATE.md" "$OUT/README.md"

  # 4) Student-facing note
  cat > "$OUT/STUDENT.md" <<'TXT'
# Your NovaGrid Security Labs

This is your working copy — and your portfolio.

- `README.md` is your **case-file front page**. Put your name on it and update a row as you finish each case.
- `EPISODES.md` is the episode index; each `epNN-*/` folder has the lab, environment setup,
  a deliverable template, a rubric and a `linkedin-post.md` draft.
- For every case: save screenshots/exports into `evidence/`, copy `deliverable-template.md`
  to `report.md` and fill it in, self-grade with `rubric.md`, then post using `linkedin-post.md`.
- New here? Read `docs/SETUP.md` to get the lab running, then `docs/portfolio/PORTFOLIO-GUIDE.md` before your first push (what not to commit, honesty, interviews).

Answer keys are not included (ask your instructor if you're stuck).
TXT
}

# -------------------------------------------------------------------- UPDATE MODE
if [ -n "$UPDATE" ]; then
  [ "$INIT" -eq 1 ]   && { echo "error: use either --update or --init, not both." >&2; exit 2; }
  [ -n "$STUDENT" ]   && { echo "error: --student is for building a fresh copy, not --update." >&2; exit 2; }
  [ -d "$UPDATE/.git" ] || { echo "error: $UPDATE is not a git repo. Use --init to create one first." >&2; exit 2; }
  OUT="$(cd "$UPDATE" && pwd)"
  echo "Updating existing student repo in place -> $OUT"
  # Overwrite instructor content / add new files. tar only writes archive members, so student
  # files (evidence/*, report.md, anything not in the master) are left untouched.
  git -C "$SRC" archive --format=tar HEAD | tar -x -C "$OUT"
  sanitize_and_package "$OUT" ""
  echo "Episodes now in the repo:"
  ls -d "$OUT"/ep*/ 2>/dev/null | sed 's|.*/\(ep[^/]*\)/|  \1|'
  ( cd "$OUT" && git add -A \
    && git -c user.name="NovaGrid Labs" -c user.email="labs@example.com" \
         commit -q -m "Sync labs from instructor master ($(date +%Y-%m-%d))" \
       && echo "  committed. Now: cd \"$OUT\" && git push   (students then: Sync fork / git pull)" \
       || echo "  nothing changed since the last sync — no commit made." )
  echo "Note: files you DELETED in the master are not auto-removed here; delete them in the student repo by hand if needed."
  exit 0
fi

# -------------------------------------------------------------------- BUILD MODE
SLUG="student"; [ -n "$STUDENT" ] && SLUG="$(slug "$STUDENT")"
[ -z "$OUT" ] && OUT="$SRC/student-build/$SLUG"
echo "Building student copy -> $OUT"
rm -rf "$OUT"; mkdir -p "$OUT"
git -C "$SRC" archive --format=tar HEAD | tar -x -C "$OUT"
sanitize_and_package "$OUT" "$STUDENT"

echo "Done. Episodes in the student copy:"
ls -d "$OUT"/ep*/ 2>/dev/null | sed 's|.*/\(ep[^/]*\)/|  \1|'

if [ "$INIT" -eq 1 ]; then
  ( cd "$OUT" && git init -q -b main && git add -A && \
    git -c user.name="NovaGrid Labs" -c user.email="labs@example.com" commit -q -m "Student copy of NovaGrid Security Labs" )
  echo "  git repo initialised in $OUT (now add a remote and push; thereafter update it with: tools/make-student-copy.sh --update \"$OUT\")"
fi
