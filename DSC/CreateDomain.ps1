Install-ADDSForest -DomainName "SQLHAU.LAB" -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssword!971" -AsPlainText -Force) -DomainMode WinThreshold -ForestMode WinThreshold -InstallDns

