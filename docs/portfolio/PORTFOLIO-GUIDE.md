# Turning the labs into a portfolio

Every episode ends with something an employer can read: a report, a detection, a risk register,
a board brief. This guide shows how to package those into a GitHub portfolio and LinkedIn posts
that hold up in an interview.

## 1. One-time setup

1. Get your student copy (from your instructor, or `tools/make-student-copy.sh --init`).
   Its `README.md` is already the **case-file template** — your portfolio front page.
   The original episode index is kept as `EPISODES.md`.
2. Create a **public** GitHub repo, e.g. `security-case-files`, and push the copy to it.
3. Edit `README.md`: your name, target role, links, and the "About me" paragraph.
4. Pin the repo on your GitHub profile and add it to the *Featured* section on LinkedIn.

## 2. Per-episode workflow

| Step | Do this |
|---|---|
| 1. Brief | Read `lab.md`. Note the mission objectives — your report must answer each one. |
| 2. Work | Follow the investigation. At every **Evidence checkpoint**, save a capture. |
| 3. Evidence | Save into `evidence/` named `NN-step-what.png`, e.g. `13-04-attacker-ip-spl.png`. Save queries as `.spl`/`.txt`, exports as `.csv`. |
| 4. Report | Copy `deliverable-template.md` → `report.md` and fill it in. Link each finding to its evidence file. |
| 5. Self-grade | Score yourself against `rubric.md`; add a short "Self-assessment" note at the end of `report.md` with your score and what you'd improve. |
| 6. Case file | In the root `README.md`, set the row's Status to ✅ and check the Deliverable link points at `report.md`. |
| 7. Post | Open `linkedin-post.md`, fill in your real results, run its checklist, and post. |
| 8. Commit | `git add epNN-*/ README.md && git commit -m "Case #NN: <title>" && git push` |

Aim for quality over count: **10 strong cases beat 30 thin ones.** Pick your best three for the
Highlights table.

## 3. What a good report shows

- **The answer first** — a 3–5 line executive summary someone non-technical can follow.
- **Evidence for every claim** — a screenshot, query or log line, linked.
- **Your reasoning** — at the lab's **Decision** points, say what you chose and why.
- **Framework mapping** — Security+ objective, MITRE ATT&CK technique (or mitigation), NIST CSF function.
- **Recommendations with owners** — "Tunde to disable root SSH by Friday", not "harden SSH".
- **Reflection** — what you'd do differently, what surprised you.

## 4. What NOT to commit

Your repo is public. Before every push, check you are not adding:

| Never commit | Instead |
|---|---|
| Real company data, real names, your employer's anything | Only NovaGrid's synthetic data |
| Secrets — your API keys, tokens, real passwords, SSH private keys | Redact; the lab's fake credentials are fine to mention |
| Malware samples, password-protected zips from malware sites | Record the **SHA-256 hash** and the source URL |
| Large pcaps, memory/disk images, VM files, BOTS datasets | Link to the public source; commit only screenshots and extracted IOCs |
| Unredacted screenshots of your real desktop, email, browser tabs | Crop to the tool window |

The repo's `.gitignore` already blocks common binary, archive and image formats — don't force-add them.

## 5. Be honest about what it is

Recruiters respect home labs; they distrust inflated ones. Always say:

- it's a **training scenario at a fictional company**, on **your own lab systems**;
- which parts used **public datasets** (BOTS, malware-traffic-analysis.net) — that's a strength, it's real attacker data;
- what you did yourself versus what the lab provided.

Never describe a lab case as client work or "an incident I handled at work".

## 6. Using it in interviews

Pick a case and tell it with **STAR** in under two minutes:

- **Situation** — "NovaGrid's CFO received a suspicious invoice email…"
- **Task** — "I had to decide if it was phishing and what to do about it."
- **Action** — the 3–4 key steps, the tools, one decision you made and why.
- **Result** — what you found, what you recommended, what you'd improve.

Then offer the repo link so they can check the evidence. Be ready for "how would this differ in
a real SOC?" — the lab's *Stretch goals* and *Verification questions* are good practice for that.
