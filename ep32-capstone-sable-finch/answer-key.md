# Answer key — Episode 32 capstone (instructor only)

> Do not include in student copies. This is a synthesis episode, so there is no single
> "correct" output — grade the **rigour and coherence** of the case file, not a key.

## What a strong submission does
- **T0 is the phishing click / credential event**, not the SOC detection. Students who put
  T0 at detection time have confused "when it started" with "when we noticed" — a common and
  important mistake to correct.
- **The earliest-stop control is MFA (M1032)** on admin logins: it breaks both the phished
  and the stuffed credentials. Accept a well-argued alternative (e.g. decommissioning
  legacy-billing removes the target entirely), but it must be defended.
- **Every kill-chain row cites evidence** from a specific earlier episode. A row with a
  technique but no evidence reference is an assertion, not a finding.
- **The exec brief is genuinely one page and jargon-free**, leads with the business impact,
  and makes **one** concrete ask. Multiple asks or a technical brief loses the point.
- **The diagram** distinguishes gaps (control failed) from catches (control worked) — this is
  the student's defensive maturity on display.

## Grading emphasis
- Weight **coherence** heavily: does it read as one story, or thirty stapled reports?
- Reward **honest framing** — a student who says plainly "this is a home-lab reconstruction
  at a fictional company" is demonstrating the professionalism employers want.
- Check the remediation actions are **owned and dated**, not vague ("improve security").

## Dependencies
The capstone assumes a spread of Episodes 11–31. A thin submission usually traces to missing
source evidence — send the student back to the specific episode (see
`environment/campaign-brief.md` for the stage→episode map) rather than grading the gap as a
writing failure.
