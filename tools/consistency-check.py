#!/usr/bin/env python3
"""Consistency check for NovaGrid Security Labs. Run from the repo root:
    python3 tools/consistency-check.py
Verifies every episode has the standard files + lab sections, rubric totals 100,
README links resolve, and flags leftover placeholders. Exit code 1 if issues."""
import os,re,sys
REQ=["README.md","lab.md","deliverable-template.md",
     "example-deliverable.md","rubric.md","answer-key.md","evidence/.gitkeep","linkedin-post.md"]
SECS=["## Cold open","## Your role & mission objectives","## Scope & rules of engagement",
      "## Environment setup","## Deliverable","## Rubric","## Framework mapping",
      "## Stretch goals","## Verification questions"]
root=os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(root)
eps=sorted(d for d in os.listdir(".") if re.match(r"ep\d\d-",d))
issues=0
def rd(p): return open(p,encoding="utf-8").read() if os.path.exists(p) else ""
for ep in eps:
    pr=[]
    for f in REQ:
        if not os.path.exists(f"{ep}/{f}"): pr.append("missing "+f)
    lab=rd(f"{ep}/lab.md")
    for s in SECS:
        if s not in lab: pr.append("lab missing "+s)
    rub=rd(f"{ep}/rubric.md")
    nums=[int(x) for x in re.findall(r"\|\s*(\d+)\s*\|\s*$",rub,re.M)]
    if nums and sum(nums)!=100: pr.append(f"rubric sums to {sum(nums)}")
    for f in ["lab.md","README.md","example-deliverable.md"]:
        for tok in ("TODO","FIXME","XXX","Lorem"):
            if tok in rd(f"{ep}/{f}"): pr.append(f"{f} has '{tok}'")
    if pr: issues+=1; print(f"[{ep}]"); [print("  -",x) for x in pr]
rdme=rd("README.md")
for l in re.findall(r"\]\((ep\d\d-[^/)]+)/\)",rdme):
    if not os.path.isdir(l): issues+=1; print("broken README link:",l)
for e in eps:
    if f"({e}/)" not in rdme: issues+=1; print("not linked in README:",e)
print(f"\n{len(eps)} episodes checked — {'OK, no issues' if not issues else str(issues)+' issue(s)'}")
sys.exit(1 if issues else 0)
