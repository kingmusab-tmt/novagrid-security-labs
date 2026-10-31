# Environment — Episode 22
Rebuild the wallet host/container from a clean base image; restore the Ep8 backup
(`sha256sum -c` to verify). Keep the compromised host isolated until forensics (Ep23) is
done. Time the rebuild+restore to measure RTO; note the backup age to measure RPO. Lab only.
