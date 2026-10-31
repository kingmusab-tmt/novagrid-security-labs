#Requires -RunAsAdministrator
<#  Remove the NovaGrid lab artifacts from the Windows target.
    The cleanest reset is to REVERT the VM to the snapshot you took after setup.
    This script is the fallback if you didn't snapshot. Run elevated:
        .\reset-windows.ps1
#>
$ErrorActionPreference = 'SilentlyContinue'
foreach ($u in 'amara','tunde','chidi','svc-backup','webadmin','contractor') { Remove-LocalUser -Name $u }
Remove-SmbShare -Name 'WalletExports' -Force
Unregister-ScheduledTask -TaskName 'NovaGridUpdater' -Confirm:$false
Remove-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'NovaGridSync'
Remove-Item -Recurse -Force 'C:\NovaGrid'
cmd /c "net accounts /minpwlen:8 /lockoutthreshold:5" | Out-Null
Write-Host "[novagrid] lab artifacts removed. (A snapshot revert is still the most thorough reset.)"
