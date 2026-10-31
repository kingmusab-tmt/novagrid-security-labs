# Episode 11 — per-student sample generator

Generates a unique, internally-consistent phishing `.eml` + inert HTML attachment (and an
instructor answer sheet) per student, so every portfolio report differs and copying is obvious.

```bash
python3 generate_sample.py --student "Jane Doe" --out ./out
```

Output: `out/<student-slug>/data/phishing-sample.eml`, the attachment, and
`out/<student-slug>/_instructor_answers.md` (keep that private).

Deterministic: the same student name always regenerates the same sample. No dependencies.
Give each student only their `data/` folder; retain the answer sheets.
