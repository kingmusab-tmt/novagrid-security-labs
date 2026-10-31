# tools/

## make-student-copy.sh
Builds a **student-facing** copy of the labs from this instructor master, with answer keys,
worked examples, the Ep11 generator, and this `tools/` folder removed.

```bash
# generic student starter
tools/make-student-copy.sh --out ./student-build/generic

# a named student (unique Ep11 phishing sample injected, no answer sheet)
tools/make-student-copy.sh --student "Jane Doe"

# ONE canonical student repo (create once), then publish updates to it
tools/make-student-copy.sh --out ../novagrid-labs-student --init     # once
tools/make-student-copy.sh --update ../novagrid-labs-student         # every time after
```

`--update` refreshes an existing student repo in place: it overwrites the instructor content
but keeps the repo's `.git` history and every student file (`evidence/`, `report.md`), then
commits — so student **forks can sync** with `git pull`. Use `--init` only once; re-running
`--init` makes a new root history and breaks forks. See `docs/SETUP.md` → *Distribution model*.

Output lands in `student-build/<slug>/` (git-ignored) unless you pass `--out`/`--update`. Keep
this master private — it holds the answers.

Requires `git` (and `python3`/`python` for the per-student Ep11 sample).

## consistency-check.py
Validates all episodes have the standard files + sections, rubric totals, and intact README links.
```bash
python3 tools/consistency-check.py
```
