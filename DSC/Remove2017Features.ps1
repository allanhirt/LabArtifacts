"C:\Program Files\Microsoft SQL Server\140\Setup Bootstrap\SQL2017\setup.exe" /action=UNINSTALL /QUIET /INDICATEPROGRESS /FEATURES=AS,ADVANCEDANALYTICS,SQL_INST_MR,FULLTEXT,DQ /INSTANCENAME=MSSQLSERVER
$Trigger= New-ScheduledTaskTrigger -At (Get-Date).AddMinutes(2) -Once
$User= "NT AUTHORITY\SYSTEM"
$Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "restart-computer"
Register-ScheduledTask -TaskName "Reboot After Removing Features" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force
