# Instructor Answer Key — Episode 20

> Private. Students' SPL will vary; grade on whether it *fires on the known events* and is
> well-reasoned, not on matching these exact searches.

## What each detection must catch (ground truth from Ep13 / BOTSv1)
1. **Scanning** → Acunetix, source **40.80.148.42** (UA signal and/or high distinct-URL count).
2. **Brute force** → many POSTs to `/administrator/index.php` from the attacker source.
3. **Successful brute force** → failure→success transition; password `batman` accepted (redirect/behaviour change).
4. **Malware delivery** → `3791.exe` on/through the web server.
5. **Defacement/callout** → `poisonivy-is-coming-for-you-batman.jpeg` and/or attacker host
   `prankglassinebracket.jumpingcrab.com` / **23.22.63.114**.

## Verification-question answers
1. The brute-force detection must return the attacker source IP hitting the Joomla admin login.
2. Success is distinguished by the server response — a redirect (302/303) or a changed
   response size after the matching POST — not by attempt count alone.
3. **UA-based** detections (Acunetix string) break if the attacker changes User-Agent;
   **behaviour-based** detections (distinct-URL volume, failure→success, IOC traffic)
   survive. Teaching point: prefer behavioural detections; treat signatures as a bonus layer.

## Grading notes
- Reward FP tuning and severity reasoning heavily — that's what separates a detection
  engineer from someone who writes a search.
- A Sigma version or a risk-based correlation alert is a strong portfolio differentiator.
