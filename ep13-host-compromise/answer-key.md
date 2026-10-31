# Instructor Answer Key — Episode 13 (BOTSv1)

> Private. BOTSv1 is a well-documented public dataset; the stable findings are below.
> Have students reproduce exact timestamps and the hash in their own instance.

## Expected findings
- **Target:** `imreallynotbatman.com` = 192.168.250.70.
- **Recon:** **Acunetix Web Vulnerability Scanner**, attacker IP **40.80.148.42** (identify via `User-Agent` in `stream:http` and `suricata` alerts).
- **Brute force:** against the Joomla **`/administrator`** login, username **`admin`**, hundreds of POST attempts; the successful password is **`batman`** (confirm by the submitted credential + the change in response behaviour/size).
- **Second attacker host:** **23.22.63.114**, domain **prankglassinebracket.jumpingcrab.com** (Po1s0n1vy infrastructure).
- **Malware:** **`3791.exe`** placed/run on the server. MD5 commonly documented as
  `AAE3F5A29935E6ABCC2C2754D12A9AF0` — have the student pull it from their data and
  confirm on VirusTotal (do not accept a copied value without a screenshot).
- **Defacement image:** `poisonivy-is-coming-for-you-batman.jpeg`.
- **Actor narrative:** Po1s0n1vy (Poison Ivy) APT.

## Verification-question answers
1. **Acunetix** scanner from **40.80.148.42**, seen first in web/IDS data.
2. Password **`batman`** on the `admin` account; success shown by the changed server
   response after the matching POST (not merely the attempt count).
3. **`3791.exe`**.

## Common student mistakes
- Setting the time picker to "last 24h" and seeing no data (data is Aug 2016).
- Counting brute-force attempts but never proving success.
- Listing the scanner IP but missing the second (content-hosting) attacker IP/domain.
- Asserting the malware hash without reproducing/enriching it.

## Anti-copying
Because each student reproduces timestamps and the hash from their own loaded instance and
writes their own SPL into `evidence/`, copied reports are easy to spot (no matching SPL,
no screenshots). For a stronger variant, assign different BOTSv1 investigation questions
per student from the official BOTSv1 question set.
