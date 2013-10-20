#
# Cookbook Name:: windomain
# Recipe:: dc
#
# Copyright (C) 2013 Stefan Scherer
# 
# All rights reserved - Do Not Redistribute
#


# this does not work at the moment
windows_reboot 5 do
  reason 'Reboot into Domain Controller'
  action :nothing
end

# from http://lyncdup.com/2013/06/setup-a-2008-r2-domain-controller-with-powershell-install-tafirst2008r2domaincontroller/
powershell "Install-TAFirst2008R2DomainController" do
  code <<-EOH
Function Install-TAFirst2008R2DomainController {
<#

.NOTES
Version: 0.1
Author : Tom Arbuthnot lyncdup.com
Disclaimer: Use completely at your own risk. Test before using on any system.
Do not run any script you don't understand.
Do not use on production systems.

.LINK
#>

# Sets that -Whatif and -Confirm should be allowed
[cmdletbinding(SupportsShouldProcess=$true)]

Param 	(
	 	[Parameter(Mandatory=$True,
                   HelpMessage="Domain name in the form domain.int")]
        [string[]]$Domain,

		[Parameter(Mandatory=$True,
                   HelpMessage="NetBios Domain name e.g. domain")]
        [string[]]$NetBiosDomainName,
		
        [Parameter(Mandatory=$false,
                   HelpMessage="First AD Site Name")]
        [string[]]$ADSite = 'lab-site1',
		
		[Parameter(Mandatory=$false,
                   HelpMessage="This entry specifies the domain functional level. This entry is based on the levels that exist in the forest when a new domain is created in an existing forest.")]
        [string[]]$Domainlevel = '4',
		
		[Parameter(Mandatory=$false,
                   HelpMessage="You must not use this entry when you install a new domain controller in an existing forest. The ForestLevel entry replaces the SetForestVersion entry that is available in Windows Server 2003.")]
        [string[]]$ForestLevel = '4',
		
		[Parameter(Mandatory=$False,
                   HelpMessage="Directory Services Safe Mode Password ")]
        [string[]]$DSSafeModePassword = 'Pa$$w0rd',
		
		
		[Parameter(Mandatory=$false,
                   HelpMessage="Error Log location, default C:\\<Command Name>_ErrorLog.txt")]
		[string]$ErrorLog = "c:\\$($myinvocation.mycommand)_ErrorLog.txt",
        [switch]$LogErrors
		
		) #Close Parameters

Begin 	{
    	Write-Verbose "Starting $($myinvocation.mycommand)"
		Write-Verbose "Error log will be $ErrorLog"
		
		# Set everytihng ok to true, this is used to stop the script if we have an issue
		# Each Try Catch Finally block, or action (within the process block of the function) depends on $EverythingOK being true
		# A dependancy step will set $everything_ok to $false, therefore other steps will be skipped
		# Variable in the script scope
		$script:EverythingOK = $true
		
		# Catch Actions Function to avoid repeating code, don't need to . source within a script
                    Function ErrorCatch-Actions 
                    {
					Param 	(
							[Parameter(Mandatory=$false,
							HelpMessage="Switch to Allow Errors to be Caught without setting EverythingOK to False, stopping other aspects of the script running")]
							# By default any errors caught will set $EverythingOK to false causing other parts of the script to be skipped
							[switch]$SetEverythingOKVariabletoTrue
							) # Close Parameters
                    # Set Everything OK to false to avoid running dependant actions
				    If ($SetEverythingOKVariabletoTrue) {$script:EverythingOK = $true}
					else {$script:EverythingOK = $false}
                    Write-Output "Everything OK set to $script:EverythingOK"
               	    # Write Errors to Screen
                    Write-Output " "
                    Write-Warning "%%% Error Catch Has Been Triggered (To log errors to text file start script with -LogErrors switch) %%%"
                    Write-Output " "
                    Write-Warning "Last Error was:"
                    Write-Output " "
				    Write-Error $Error[0]
               	       if ($LogErrors) {
									    # Add Date to Error Log File
                                        Get-Date -format "dd/MM/yyyy HH:mm" | Out-File $ErrorLog -Append
									    # Output Error to Error Log file
									    $Error | Out-File $ErrorLog -Append
                                        "%%%%%%%%%%%%%%%%%%%%%%%%%% LINE BREAK BETWEEN ERRORS %%%%%%%%%%%%%%%%%%%%%%%%%%" | Out-File $ErrorLog -Append
                                        " " | Out-File $ErrorLog -Append
									    Write-Warning "Errors Logged to $ErrorLog"
                                        # Clear Error Log Variable
                                        $Error.Clear()
                                        } #Close If
                    } # Close Error-CatchActons Function
		    
		} #Close Function Begin Block

Process {
    		
		
		If ($script:EverythingOK)
		{
		Try 	{
                
					# Install the correct Server Role for DC
			Import-Module ServerManager
			
			# Best to install these by splitting them out
			
			add-windowsfeature GPMC, Backup-Features, Backup, Backup-Tools,DNS,WINS-Server -Verbose
			
			Add-WindowsFeature AS-NET-Framework -Verbose
			
			Add-WindowsFeature AD-Domain-Services, ADDS-Domain-Controller -Verbose
			
			# DomainLevel
			# 0 | 2 | 3
			# No default
			# This entry specifies the domain functional level. This entry is based on the levels that exist in the forest when a new domain is created in an existing forest. Value descriptions are as follows:
			# 0 = Windows 2000 Server native mode
			# 2 = Windows Server 2003
			# 3 = Windows Server 2008
			# $Domainlevel = 4
			
			# http://support.microsoft.com/kb/947034
			
			# ForestLevel
			# 0 | 2 | 3
			# This entry specifies the forest functional level when a new domain is created in a new forest as follows:
			# 0 = Windows 2000 Server
			# 2 = Windows Server 2003
			# 3 = Windows Server 2008
			# You must not use this entry when you install a new domain controller in an existing forest. The ForestLevel entry replaces the SetForestVersion entry that is available in Windows Server 2003.
			
			# $ForestLevel = 4
			
			
			# Build our DC Promo Config file
$DCPromoFile = @"
[DCINSTALL]
InstallDNS=yes
NewDomain=forest
NewDomainDNSName=$Domain
DomainNetBiosName=$NetBiosDomainName
SiteName=$ADSite
ReplicaorNewDomain=domain
ForestLevel=$ForestLevel
DomainLevel=$Domainlevel
ConfirmGC=Yes
SafeModeAdminPassword=$DSSafeModePassword
RebootonCompletion=No
"@
			
			# Output config file to text file
			$DCPromoFile | out-file c:\\dcpromoanswerfile.txt  -Force
			
			# Run DCPromo with the correct config
			dcpromo.exe /unattend:c:\\dcpromoanswerfile.txt
             
			 } # Close Try Block
			
		Catch 	{ErrorCatch-Actions}
			   
		
		} # Close First If Everthing OK Block
		
		
		# Next Script Action or Try,Catch Block goes here
		
		} #Close Function Process Block

End 	{
    	Write-Verbose "Ending $($myinvocation.mycommand)"
		} #Close Function End Block
	
 
} #End Function
Install-TAFirst2008R2DomainController -domain #{node[:domain][:domainname]} -netbiosdomainname #{node[:domain][:netbiosdomainname]} -ADSite #{node[:domain][:sitename]}

  EOH

  notifies :request, 'windows_reboot[5]'
end


# the windows_reboot does not work at the moment, so do it manually here.
windows_batch "shutdown" do
  code <<-EOH
  shutdown /r /t 10 /c "Restart into Domain Controller"
  EOH
end
