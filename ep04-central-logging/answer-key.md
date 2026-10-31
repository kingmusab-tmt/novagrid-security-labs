# Instructor Answer Key — Episode 4
- Failed SSH logins: in `auth.log` / journald ssh unit ("Failed password"). Must prove it reached the COLLECTOR, not just locally.
- TCP vs UDP: TCP (reliable) preferred for security logs; UDP can silently drop.
- Time sync: essential so multi-host timelines line up; without it correlation is unreliable.
- Retention: any justified number (e.g. 90 days) balancing investigation vs storage; note some regs mandate minimums.
- Verification: (1) auth.log + central-delivery proof; (2) time-sync rationale; (3) retention + driver.
