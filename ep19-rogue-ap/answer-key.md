# Instructor Answer Key — Episode 19
- Rogue AP = unauthorised AP on the network; evil twin = impostor copying a legit SSID. This is an evil twin.
- Impostor in survey.csv: BSSID 62:1A:9F:D4:7E:33 — duplicate "NovaGrid-WiFi" SSID but locally-administered/unknown MAC (real APs are Cisco), **Open** auth (real = WPA2-Enterprise), unusually strong signal.
- Risk: adversary-in-the-middle — captive-portal credential harvest, TLS downgrade, session theft.
- Best preventive control: 802.1X/EAP-TLS (and WPA3) so clients authenticate the network; add WIDS + client policy + awareness.
- Ethics graded: no deauth/jamming/attacks — assessment only.
- Verification: (1) rogue vs evil twin; (2) the impostor BSSID + attributes; (3) 802.1X/EAP-TLS as the key control.
