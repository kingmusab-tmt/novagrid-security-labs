# Instructor Answer Key — Episode 23
- Order of volatility: cache, RAM, swap/pagefile, disk, remote/logs — most to least volatile; RAM first because it's lost on power-off (ties to Ep21 keeping the host powered).
- Hashing: equal source/image hashes prove the image is bit-identical/unaltered; a write-blocker prevents writing to the original during acquisition.
- Always analyse a COPY; never the original.
- Chain of custody records who/what/when/where + every handoff; gaps, unlogged access, or a hash mismatch invalidate it (inadmissible).
- Verification: (1) order + RAM-first; (2) hashing + write-blocker; (3) custody contents + what breaks it.
