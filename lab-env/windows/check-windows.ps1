#Requires -RunAsAdministrator
<#  NovaGrid Windows target health/ground-truth check (instructor tool).
    Confirms the intentionally-weak state is present. Run elevated:
        .\check-windows.ps1
#>
$ok = 0; $bad = 0
function Chk($cond, $msg) {
    if ($cond) { Write-Host "  OK    $msg" -ForegroundColor Green; $script:ok++ }
    else       { Write-Host "  MISS  $msg" -ForegroundColor Yellow; $script:bad++ }
}
Write-Host "NovaGrid Windows target check"
Chk ([bool](Get-LocalUser -Name contractor -ErrorAction SilentlyContinue)) "leaver account 'contractor' exists"
Chk ((Get-LocalUser -Name contractor).Enabled) "contractor is still ENABLED (offboarding gap)"
Chk (((Get-LocalGroupMember -Group Administrators).Name) -match 'svc-backup') "svc-backup is over-privileged (local admin)"
Chk ((Get-LocalUser -Name webadmin).PasswordNeverExpires) "webadmin password never expires (stale)"
Chk (Test-Path 'C:\NovaGrid\wallet\exports\old_payments_backup.csv') "card-data export present"
Chk ([bool](Get-SmbShare -Name WalletExports -ErrorAction SilentlyContinue)) "WalletExports share is exposed"
Chk (((Get-Acl 'C:\NovaGrid\wallet\wallet.conf').Access.IdentityReference) -match 'Everyone') "wallet.conf readable by Everyone"
Chk ((Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections -eq 0) "RDP is enabled (attack surface)"
Chk ([bool](Get-ScheduledTask -TaskName NovaGridUpdater -ErrorAction SilentlyContinue)) "persistence scheduled task present (Ep21 target)"
Chk ([bool]((Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -ErrorAction SilentlyContinue).NovaGridSync)) "persistence Run key present (Ep21 target)"
Write-Host ("{0} present, {1} missing" -f $ok, $bad)
