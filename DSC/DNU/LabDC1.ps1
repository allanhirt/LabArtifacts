Configuration ConfigLabDC1
{
 
    [CmdletBinding()]
 
    param 
    (
        [PSCredential]$domainAdminCredentials
    )
 
#    Import-DscResource -ModuleName PSDesiredStateConfiguration, xActiveDirectory, xDSCFirewall
    Import-DscResource -ModuleName PSDesiredStateConfiguration
 
    Node 'localhost'
    {
            LocalConfigurationManager
            {
                ConfigurationMode = 'ApplyOnly'
                RebootNodeIfNeeded = $true
                ActionAfterReboot = 'ContinueConfiguration'
                AllowModuleOverwrite = $true
            }
 
            WindowsFeature RSAT_DNS
            { 
                Ensure = 'Present'
                Name = 'RSAT-DNS-Server'
            }
 
            WindowsFeature ADDS 
            { 
                Ensure = 'Present'
                Name = 'AD-Domain-Services'
            } 
 
            WindowsFeature RSAT_AD_AdminCenter 
            {
                Ensure = 'Present'
                Name   = 'RSAT-AD-AdminCenter'
            }
 
            WindowsFeature RSAT_ADDS 
            {
                Ensure = 'Present'
                Name   = 'RSAT-ADDS'
            }
 
            WindowsFeature RSAT_AD_PowerShell 
            {
                Ensure = 'Present'
                Name   = 'RSAT-AD-PowerShell'
            }
 
            WindowsFeature RSAT_AD_Tools 
            {
                Ensure = 'Present'
                Name   = 'RSAT-AD-Tools'
            }
 
            WindowsFeature RSAT_Role_Tools 
            {
                Ensure = 'Present'
                Name   = 'RSAT-Role-Tools'
            }      
 
            WindowsFeature RSAT_GPMC 
            {
                Ensure = 'Present'
                Name   = 'GPMC'
            } 
 
#            xADDomain CreateNewADForest 
#            { 
#                DomainName = 'SQLHAU.LAB'          
#                DomainAdministratorCredential = $domainAdminCredentials
#                SafemodeAdministratorPassword = $domainAdminCredentials
#                DatabasePath = 'C:\Windows\NTDS'
#                LogPath = 'C:\Windows\NTDS'
#                SysvolPath = 'C:\Windows\Sysvol'
#                DependsOn = '[WindowsFeature]ADDS'
#            }

#            xADRecycleBin EnableRecyclingBin 
#            {
#                ForestFQDN = 'SQLHAU.LAB'
#                EnterpriseAdministratorCredential = $domainAdminCredentials
#                DependsOn = '[xADDomain]CreateNewADForest'
#            }

#            xADUser cluadmin 
#            {
#                Ensure = 'Present'
#                DomainName = 'SQLHAU.LAB'
#                UserName = 'cluadmin'
#                Password = 'P@ssword1'
#                PasswordNeverExpires = $true            
#                DependsOn = '[xADDomain]CreateNewADForest'            
#            }

#            xADUser sql2017svcacct 
#            {
#                Ensure = 'Present'
#                DomainName = 'SQLHAU.LAB'
#                UserName = 'sql2017svcacct'
#                Password = 'P@ssword1'
#                PasswordNeverExpires = $true            
#                DependsOn = '[xADDomain]CreateNewADForest'            
#            }

#            xADUser sql2017agtsvcacct 
#            {
#                Ensure = 'Present'
#                DomainName = 'SQLHAU.LAB'
#                UserName = 'sql2017agtacct'
#                Password = 'P@ssword1'
#                PasswordNeverExpires = $true
#                DependsOn = '[xADDomain]CreateNewADForest'            
#            }

#            xADGroup DBAs 
#            {
#                Ensure = 'Present'
#                GroupName = 'DBAs'
#                MembersToInclude = 'cluadmin'
#                DependsOn = '[xADUser]cluadmin'
#            }

#            xDSCFirewall DisablePublicFW 
#            {
#                Ensure = 'Absent'
#                Zone = 'Public'
#            }

#            xDSCFirewall DisablePrivateFW 
#            {
#                Ensure = 'Absent'
#                Zone = 'Private'
#            }

#            xDSCFirewall DisableDomainFW 
#            {
#                Ensure = 'Absent'
#                Zone = 'Domain'
#            }

    }

}