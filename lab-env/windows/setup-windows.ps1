#Requires -RunAsAdministrator
<#
    NovaGrid Windows target provisioner  —  LAB USE ONLY
    --------------------------------------------------------------------------------
    Plants the SAME intentionally-weak state as the Linux wallet-api, so the Windows
    versions of Episodes 1-8, 10, 21, 23 and 24 have real ground truth to find.

    Everything here is INERT and uses SYNTHETIC data. Run it ONLY on a throwaway
    Windows evaluation VM that is isolated from any real/work network. Snapshot the VM
    first. The script is re-runnable (idempotent).

    Usage (elevated PowerShell, from this folder):
        Set-ExecutionPolicy -Scope Process Bypass -Force
        .\setup-windows.ps1
#>
$ErrorActionPreference = 'Stop'
Write-Host "[novagrid] provisioning Windows target (lab only)..." -ForegroundColor Cyan

# ---------------------------------------------------------------- 1. Local users (fake, weak)
$pw    = ConvertTo-SecureString 'NovaGrid!2026' -AsPlainText -Force
$users = [ordered]@{
    amara        = 'Amara Okafor - SOC Lead'
    tunde        = 'Tunde Bello - Sysadmin'
    chidi        = 'Chidi Nwosu - CFO'
    'svc-backup' = 'Backup service account - owner tunde'
    webadmin     = 'Web admin (2025 contractor)'
    contractor   = 'PayBridge integration contractor'
}
foreach ($u in $users.Keys) {
    if (-not (Get-LocalUser -Name $u -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $u -Password $pw -FullName $users[$u] -Description $users[$u] | Out-Null
        Write-Host "  + user $u"
    }
}
# tunde uses the reused/breached password from the Episode 2 story
Set-LocalUser -Name tunde -Password (ConvertTo-SecureString 'Tunde@2024' -AsPlainText -Force)

# ---------------------------------------------------------------- 2. Admin rights (mirrors sudo)
foreach ($u in 'amara','tunde','webadmin','contractor','svc-backup') {
    if (-not (Get-LocalGroupMember -Group 'Administrators' -Member $u -ErrorAction SilentlyContinue)) {
        Add-LocalGroupMember -Group 'Administrators' -Member $u -ErrorAction SilentlyContinue
    }
}
# svc-backup "only needs backup rights" but is a full local admin -> over-privilege finding
Add-LocalGroupMember -Group 'Backup Operators' -Member 'svc-backup' -ErrorAction SilentlyContinue

# ---------------------------------------------------------------- 3. Stale / leaver accounts
Set-LocalUser   -Name webadmin   -PasswordNeverExpires $true      # stale: never forced to change
Enable-LocalUser -Name contractor -ErrorAction SilentlyContinue   # leaver still enabled + admin

# ---------------------------------------------------------------- 4. Weak password/lockout policy
# mirrors pwquality minlen=6 and no account lockout
cmd /c "net accounts /minpwlen:6 /maxpwage:unlimited /lockoutthreshold:0" | Out-Null

# ---------------------------------------------------------------- 5. Seed data (PII + test PANs + HR)
$root = 'C:\NovaGrid'
New-Item -ItemType Directory -Force -Path "$root\wallet\data","$root\wallet\exports","$root\hr","$root\tools" | Out-Null
Copy-Item "$PSScriptRoot\seed\customers.csv"            "$root\wallet\data\customers.csv"            -Force
Copy-Item "$PSScriptRoot\seed\old_payments_backup.csv" "$root\wallet\exports\old_payments_backup.csv" -Force
Copy-Item "$PSScriptRoot\seed\staff-roster.csv"        "$root\hr\staff-roster.csv"                   -Force
Copy-Item "$PSScriptRoot\seed\asset-register.csv"      "$root\hr\asset-register.csv"                 -Force
Copy-Item "$PSScriptRoot\seed\wallet.conf"             "$root\wallet\wallet.conf"                    -Force

# ---------------------------------------------------------------- 6. World-readable secret (mirrors chmod 644)
icacls "$root\wallet\wallet.conf" /grant "*S-1-1-0:(R)" | Out-Null   # S-1-1-0 = Everyone

# ---------------------------------------------------------------- 7. Exposed export share (mirrors the :8000 leak)
if (-not (Get-SmbShare -Name 'WalletExports' -ErrorAction SilentlyContinue)) {
    New-SmbShare -Name 'WalletExports' -Path "$root\wallet\exports" -ReadAccess 'Everyone' | Out-Null
}

# ---------------------------------------------------------------- 8. Attack surface: RDP on + allowed
Set-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
Enable-NetFirewallRule -DisplayGroup 'Remote Desktop' -ErrorAction SilentlyContinue

# ---------------------------------------------------------------- 9. INERT persistence (Episode 21 target)
# a harmless "beacon" that only appends a timestamp to a log - nothing malicious
$beacon = "$root\tools\beacon.ps1"
Set-Content -Path $beacon -Value 'Add-Content "C:\NovaGrid\tools\beacon.log" ((Get-Date).ToString() + " beacon")' -Force
if (-not (Get-ScheduledTask -TaskName 'NovaGridUpdater' -ErrorAction SilentlyContinue)) {
    $act = New-ScheduledTaskAction  -Execute 'powershell.exe' -Argument "-NoProfile -WindowStyle Hidden -File `"$beacon`""
    $trg = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -TaskName 'NovaGridUpdater' -Action $act -Trigger $trg -RunLevel Highest -User 'SYSTEM' -Description 'NovaGrid (lab) - inert persistence example' | Out-Null
}
# a Run-key persistence example as well (inert)
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'NovaGridSync' `
    -Value "powershell -NoProfile -WindowStyle Hidden -File `"$beacon`"" -PropertyType String -Force | Out-Null

Write-Host "[novagrid] done. Take a VM snapshot now, then verify with .\check-windows.ps1" -ForegroundColor Green
