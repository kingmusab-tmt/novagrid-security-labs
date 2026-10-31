# Instructor Answer Key — Episode 16
- SQLi success (e.g. `' OR 1=1--`) proves input is concatenated into the query → fix is prepared/parameterised statements (+ least-privilege DB user, generic errors). Input filtering alone is insufficient.
- XSS: reflected (in the response to the request) vs stored (persisted, hits all viewers — generally worse). Fix = context-aware output encoding + CSP + validation; rely on framework auto-escaping.
- Ethics is graded: local/owned targets only.
- Verification: (1) payload + what it reveals; (2) reflected vs stored; (3) why parameterisation is the correct fix.
