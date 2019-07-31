configuration LabDC 
{ 
   param 
   ( 
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    ) 
    
    Import-DscResource -ModuleName xActiveDirectory, xNetworking, PSDesiredStateConfiguration, xPendingReboot, xDSCFirewall
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
    $Interface=Get-NetAdapter|Where Name -Like "Ethernet*"|Select-Object -First 1
    $InterfaceAlias=$($Interface.Name)

    Node localhost
    {
            LocalConfigurationManager 
            {
                RebootNodeIfNeeded = $true
            }

	        WindowsFeature DNS 
            { 
                Ensure = "Present" 
                Name = "DNS"		
            }

            Script EnableDNSDiags
	        {
      	        SetScript = { 
		            Set-DnsServerDiagnostics -All $true
                    Write-Verbose -Verbose "Enabling DNS client diagnostics" 
                }
                GetScript =  { @{} }
                TestScript = { $false }
	            DependsOn = "[WindowsFeature]DNS"
            }

    	    WindowsFeature DnsTools
	        {
	            Ensure = "Present"
                Name = "RSAT-DNS-Server"
                DependsOn = "[WindowsFeature]DNS"
	        }

            xDnsServerAddress DnsServerAddress 
            { 
                Address        = '127.0.0.1' 
                InterfaceAlias = $InterfaceAlias
                AddressFamily  = 'IPv4'
	            DependsOn = "[WindowsFeature]DNS"
            }

            WindowsFeature ADDSInstall 
            { 
                Ensure = "Present" 
                Name = "AD-Domain-Services"
	            DependsOn="[WindowsFeature]DNS" 
            } 

            WindowsFeature ADDSTools
            {
                Ensure = "Present"
                Name = "RSAT-ADDS-Tools"
                DependsOn = "[WindowsFeature]ADDSInstall"
            }

            WindowsFeature ADAdminCenter
            {
                Ensure = "Present"
                Name = "RSAT-AD-AdminCenter"
                DependsOn = "[WindowsFeature]ADDSInstall"
            }
    
  
            xADDomain CreateNewForest 
            {
                DomainName = $DomainName
                DomainAdministratorCredential = $DomainCreds
                SafemodeAdministratorPassword = $DomainCreds
                DatabasePath = "C:\NTDS"
                LogPath = "C:\NTDS"
                SysvolPath = "C:\SYSVOL"
                DependsOn = "[WindowsFeature]ADDSInstall"
            } 

            xADRecycleBin EnableRecyclingBin 
            {
                ForestFQDN = 'SQLHAU.LAB'
                EnterpriseAdministratorCredential = $Credential
                DependsOn = '[xADDomain]CreateNewADForest'
            }

            xADUser cluadmin 
            {
                Ensure = 'Present'
                DomainName = 'SQLHAU.LAB'
                UserName = 'cluadmin'
                Password = 'P@ssword1'
                PasswordNeverExpires = $true            
                DependsOn = '[xADDomain]CreateNewADForest'            
            }

            xADUser sql2017svcacct 
            {
                Ensure = 'Present'
                DomainName = 'SQLHAU.LAB'
                UserName = 'sql2017svcacct'
                Password = 'P@ssword1'
                PasswordNeverExpires = $true            
                DependsOn = '[xADDomain]CreateNewADForest'            
            }

            xADUser sql2017agtsvcacct 
            {
                Ensure = 'Present'
                DomainName = 'SQLHAU.LAB'
                UserName = 'sql2017agtacct'
                Password = 'P@ssword1'
                PasswordNeverExpires = $true
                DependsOn = '[xADDomain]CreateNewADForest'            
            }

            xADGroup DBAs 
            {
                Ensure = 'Present'
                GroupName = 'DBAs'
                MembersToInclude = 'cluadmin'
                DependsOn = '[xADUser]cluadmin'
            }

            xDSCFirewall DisablePublicFW 
            {
                Ensure = 'Absent'
                Zone = 'Public'
            }

            xDSCFirewall DisablePrivateFW 
            {
                Ensure = 'Absent'
                Zone = 'Private'
            }

            xDSCFirewall DisableDomainFW 
            {
                Ensure = 'Absent'
                Zone = 'Domain'
            }


    }

}
