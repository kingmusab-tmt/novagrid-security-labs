# tools/

## make-student-copy.sh
Builds a **student-facing** copy of the labs from this instructor master, with answer keys,
worked examples, the Ep11 generator, and this `tools/` folder removed.

```bash
# generic student starter
tools/make-student-copy.sh --out ./student-build/generic

# a named student (unique Ep11 phishing sample injected, no answer sheet)
tools/make-student-copy.sh --student "Jane Doe"

# ready-to-push repo for the student
tools/make-student-copy.sh --student "Jane Doe" --init
```

Output lands in `student-build/<slug>/` (git-ignored). Give the student that folder (or
push it as their own private repo). Keep this master private — it holds the answers.

Requires `git` (and `python3`/`python` for the per-student Ep11 sample).

## consistency-check.py
Validates all episodes have the standard files + sections, rubric totals, and intact README links.
```bash
python3 tools/consistency-check.py
```
