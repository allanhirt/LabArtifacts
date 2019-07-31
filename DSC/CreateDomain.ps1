Install-ADDSForest -DomainName "SQLHAU.LAB" -NoRebootOnCompletion -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssword!971" -AsPlainText -Force) -DomainMode WinThreshold -ForestMode WinThreshold -InstallDns
$Trigger= New-ScheduledTaskTrigger -At (Get-Date).AddMinutes(2) -Once
$User= "NT AUTHORITY\SYSTEM"
$Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "restart-computer"
Register-ScheduledTask -TaskName "Reboot After AD Forest Configuration" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force
