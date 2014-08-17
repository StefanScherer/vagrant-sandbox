<#
--------------
WSUS Installer v1
--------------
by Trevor Jones

This script installs and configures WSUS on a Windows 2012 server.
You have the option to use WID, Local SQL Express or an existing SQL Server. 
If you choose Local SQL Express it will be downloaded and installed for you with a default configuration.
Report Viewer 2008 is also optionally installed, it is required to view WSUS reports.
The script will do an initial configuration of WSUS including:
  > Set sync from Microsoft Update
  > Set updates language to English
  > Set the WSUS Products to Sync (edit in the script if required)
  > Set the WSUS Categories to Sync (edit in the script if required)
  > Enable scheduled WSUS sync at midnight every night
The script is designed to be run in Powershell ISE

//Prereqs//
- Powershell 4.0
- Run as administrator
- Windows OS Media, if you want the script to install .Net Framework 3.5 for you, else you need to do it manually first
- Internet connectivity
- Set the variables below
#>



###############
## Variables ##
###############

##//INSTALLATION//##

# Do you want to install .NET FRAMEWORK 3.5? If true, provide a location for the Windows OS media in the next variable
    $DotNet = $True
# Location of Windows sxs for .Net Framework 3.5 installation
    $WindowsSXS = "D:\sources\sxs"
# Do you want to download and install MS Report Viewer 2008 SP1 (required for WSUS Reports)?
    $RepViewer = $True
# WSUS Installation Type.  Enter "WID" (for WIndows Internal Database), "SQLExpress" (to download and install a local SQLExpress), or "SQLRemote" (for an existing SQL Instance).  
    $WSUSType = "SQLExpress"
# If using an existing SQL server, provide the Instance name below
    $SQLInstance = "MyServer\MyInstance"
# Location to store WSUS Updates (will be created if doesn't exist)
    $WSUSDir = "C:\WSUS_Updates"
# Temporary location for installation files (will be created if doesn't exist)
    $TempDir = "C:\temp"


##//CONFIGURATION//##

# Do you want to configure WSUS (equivalent of WSUS Configuration Wizard, plus some additional options)?  If $false, no further variables apply.
# You can customise the configurations, such as Products and Classifications etc, in the "Begin Initial Configuration of WSUS" section of the script.
    $ConfigureWSUS = $True
# Do you want to decline some unwanted updates?
    $DeclineUpdates = $True
# Do you want to configure and enable the Default Approval Rule?
    $DefaultApproval = $True
# Do you want to run the Default Approval Rule after configuring?
    $RunDefaultRule = $True



#####################
## Start of Script ##
#####################

$ErrorActionPreference = "Inquire"
cls
write-host ' ' 
write-host ' ' 
write-host ' ' 
write-host ' ' 
write-host ' ' 
write-host ' ' 
write-host '#######################' 
write-host '## WSUS INSTALLATION ##'
write-host '#######################' 
write-host ' ' 
write-host ' '



# Create temp folder for downloads if doesn't exist

if(Test-Path $TempDir)
{
$Tempfolder = "Yes"}
else{$Tempfolder = "No"}

If ($Tempfolder -eq "No")
{
New-Item $TempDir -type directory | Out-null
}



# Install .Net Framework 3.5 from media
if($DotNet -eq $true)
{
write-host 'Installing .Net Framework 3.5'
Install-WindowsFeature -name NET-Framework-Core -Source $WindowsSXS
}



# Download MS Report Viewer 2008 SP1 for WSUS reports

if ($RepViewer -eq $True)
{
$URL = "http://download.microsoft.com/download/3/a/e/3aeb7a63-ade6-48c2-9b6a-d3b6bed17fe9/ReportViewer.exe"
if (!(Test-Path 'c:\vagrant\resources\ReportViewer.exe')) {
  write-host "Downloading Microsoft Report Viewer 2008 SP1...please wait"
  (New-Object Net.WebClient).DownloadFile($URL, "c:\vagrant\resources\ReportViewer.exe")
}

# Install MS Report Viewer 2008 SP1

write-host 'Installing Microsoft Report Viewer 2008 SP1...'
$setup=Start-Process "c:\vagrant\resources\ReportViewer.exe" -verb RunAs -ArgumentList '/q' -Wait -PassThru
if ($setup.exitcode -eq 0)
{
write-host "Successfully installed" 
}
else
{
write-host 'Microsoft Report Viewer 2008 SP1 did not install correctly.' -ForegroundColor Red
write-host 'Please download and install it manually to use WSUS Reports.' -ForegroundColor Red
write-host 'Continuing anyway...' -ForegroundColor Magenta
}
}



# Download SQL 2012 Express SP1 with tools

if ($WSUSType -eq 'SQLExpress')
{
if (!(Test-Path 'c:\vagrant\resources\ReportViewer.exe')) {
  write-host "Downloading SQL 2012 Express SP1 with Tools...please wait"
  $URL = "http://download.microsoft.com/download/5/2/9/529FEF7B-2EFB-439E-A2D1-A1533227CD69/SQLEXPRWT_x64_ENU.exe"
  (New-Object Net.WebClient).DownloadFile($URL, "c:\vagrant\resources\SQLEXPRWT_x64_ENU.exe")
}


# Install SQL 2012 Express with defaults

write-host 'Installing SQL Server 2012 SP1 Express with Tools...'
$setup=Start-Process "c:\vagrant\resources\SQLEXPRWT_x64_ENU.exe" -verb RunAs -ArgumentList '/Q /IACCEPTSQLSERVERLICENSETERMS /ACTION=INSTALL /ROLE=ALLFEATURES_WITHDEFAULTS /INSTANCENAME=SQLEXPRESS /SQLSYSADMINACCOUNTS="BUILTIN\ADMINISTRATORS" /UPDATEENABLED=TRUE /UPDATESOURCE="MU"' -Wait -PassThru

if ($setup.exitcode -eq 0)
{
write-host "Successfully installed" 
}
else
{
write-host 'SQL Server 2012 SP1 Express did not install correctly.' -ForegroundColor Red
write-host 'Please check the Summary.txt log at C:\Program Files\Microsoft SQL Server\110\Setup Bootstrap\Log' -ForegroundColor Red
write-host 'The script will stop now.' -ForegroundColor Red
break
}
}


# Install WSUS (WSUS Services, SQL Database, Management tools)

if ($WSUSType -eq 'WID')
{
write-host 'Installing WSUS for WID (Windows Internal Database)'
Install-WindowsFeature -Name UpdateServices -IncludeManagementTools
}
if ($WSUSType -eq 'SQLExpress' -Or $WSUSType -eq 'SQLRemote')
{
write-host 'Installing WSUS for SQL Database'
Install-WindowsFeature -Name UpdateServices-Services,UpdateServices-DB -IncludeManagementTools
}



## Create WSUS Updates folder if doesn't exist

if(Test-Path $WSUSDir)
{
$WSUSfolder = "Yes"}
else{$WSUSfolder = "No"}

If ($WSUSfolder -eq "No")
{
New-Item $WSUSDir -type directory | Out-null
}



Write-Host "Run WSUS Post-Configuration"

if ($WSUSType -eq 'WID')
{
sl "C:\Program Files\Update Services\Tools"
.\wsusutil.exe postinstall CONTENT_DIR=$WSUSDir
}
if ($WSUSType -eq 'SQLExpress') 
{
sl "C:\Program Files\Update Services\Tools"
.\wsusutil.exe postinstall SQL_INSTANCE_NAME="%COMPUTERNAME%\SQLEXPRESS" CONTENT_DIR=$WSUSDir
}
if ($WSUSType -eq 'SQLRemote') 
{
sl "C:\Program Files\Update Services\Tools"
.\wsusutil.exe postinstall SQL_INSTANCE_NAME=$SQLInstance CONTENT_DIR=$WSUSDir
}



Write-Host "Begin Initial Configuration of WSUS"

if ($ConfigureWSUS -eq $True)
{
# Get WSUS Server Object
$wsus = Get-WSUSServer

# Connect to WSUS server configuration
$wsusConfig = $wsus.GetConfiguration()

# Set to download updates from Microsoft Updates
Set-WsusServerSynchronization –SyncFromMU

# Set Update Languages to English and save configuration settings
$wsusConfig.AllUpdateLanguagesEnabled = $false           
$wsusConfig.SetEnabledUpdateLanguages("en")           
$wsusConfig.Save()

# Get WSUS Subscription and perform initial synchronization to get latest categories
$subscription = $wsus.GetSubscription()
$subscription.StartSynchronizationForCategoryOnly()
write-host 'Beginning first WSUS Sync to get available Products etc' -ForegroundColor Magenta
write-host 'Will take some time to complete'
while ($subscription.GetSynchronizationProgress().ProcessedItems -ne $subscription.GetSynchronizationProgress().TotalItems) {            
    Write-Progress -PercentComplete (            
    $subscription.GetSynchronizationProgress().ProcessedItems*100/($subscription.GetSynchronizationProgress().TotalItems)            
    ) -Activity "WSUS Sync Progress"            
} 
Write-Host "Sync is done." -ForegroundColor Green

# Configure the Platforms that we want WSUS to receive updates
write-host 'Setting WSUS Products'
Get-WsusProduct | where-Object {
    $_.Product.Title -in (
#    'Report Viewer 2005',
#    'Report Viewer 2008',
#    'Report Viewer 2010',
#    'Visual Studio 2005',
#    'Visual Studio 2008',
#    'Visual Studio 2010 Tools for Office Runtime',
#    'Visual Studio 2010',
#    'Visual Studio 2012',
#    'Visual Studio 2013',
#    'Microsoft Lync 2010',
#    'Microsoft SQL Server 2008 R2 - PowerPivot for Microsoft Excel 2010',
#    'Dictionary Updates for Microsoft IMEs',
#    'New Dictionaries for Microsoft IMEs',
#    'Office 2003',
#    'Office 2010',
#    'Office 2013',
    'Silverlight',
#    'System Center 2012 - Orchestrator',
    'Windows 7'
#    'Windows 8.1 Drivers',
#    'Windows 8.1 Dynamic Update',
#    'Windows 8',
#    'Windows Dictionary Updates',
#    'Windows Server 2008 R2',
#    'Windows Server 2008',
#    'Windows Server 2012 R2',
#    'Windows Server 2012',
#    'Windows XP 64-Bit Edition Version 2003',
#    'Windows XP x64 Edition',
#    'Windows XP'
    )
} | Set-WsusProduct

# Configure the Classifications
write-host 'Setting WSUS Classifications'
Get-WsusClassification | Where-Object {
    $_.Classification.Title -in (
    'Critical Updates',
    'Definition Updates',
    'Feature Packs',
    'Security Updates',
    'Service Packs',
    'Update Rollups',
    'Updates')
} | Set-WsusClassification

# Prompt to check products are set correctly
#write-host 'Before continuing, please open the WSUS Console, cancel the WSUS Configuration Wizard,' - -ForegroundColor Red
#write-host 'Go to Options > Products and Classifications, and check that the Products are set correctly.' - -ForegroundColor Red
#write-host 'Pausing script' -ForegroundColor Yellow
#$Shell = New-Object -ComObject "WScript.Shell"
#$Button = $Shell.Popup("Click OK to continue.", 0, "Script Paused", 0) # Using Pop-up in case script is running in ISE

# Configure Synchronizations
write-host 'Enabling WSUS Automatic Synchronisation'
$subscription.SynchronizeAutomatically=$true

# Set synchronization scheduled for midnight each night
$subscription.SynchronizeAutomaticallyTimeOfDay= (New-TimeSpan -Hours 0)
$subscription.NumberOfSynchronizationsPerDay=1
$subscription.Save()

# Kick off a synchronization
$subscription.StartSynchronization()



# Monitor Progress of Synchronisation

write-host 'Beginning full WSUS Sync, will take some time' -ForegroundColor Magenta   
Start-Sleep -Seconds 60 # Wait for sync to start before monitoring      
while ($subscription.GetSynchronizationProgress().ProcessedItems -ne $subscription.GetSynchronizationProgress().TotalItems) {            
    Write-Progress -PercentComplete (            
    $subscription.GetSynchronizationProgress().ProcessedItems*100/($subscription.GetSynchronizationProgress().TotalItems)            
    ) -Activity "WSUS Sync Progress"            
}  
Write-Host "Sync is done." -ForegroundColor Green



# Decline Unwanted Updates

if ($DeclineUpdates -eq $True)
{
write-host 'Declining Unwanted Updates'
$approveState = 'Microsoft.UpdateServices.Administration.ApprovedStates' -as [type]

# Declining All Internet Explorer 10
$updateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope -Property @{
    TextIncludes = '2718695'
    ApprovedStates = $approveState::Any
}
$wsus.GetUpdates($updateScope) | ForEach {
    Write-Verbose ("Declining {0}" -f $_.Title) -Verbose
    $_.Decline()
}

# Declining Microsoft Browser Choice EU
$updateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope -Property @{
    TextIncludes = '976002'
    ApprovedStates = $approveState::Any
}
$wsus.GetUpdates($updateScope) | ForEach {
    Write-Verbose ("Declining {0}" -f $_.Title) -Verbose
    $_.Decline()
}

# Declining all Itanium Update
$updateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope -Property @{
    TextIncludes = 'itanium'
    ApprovedStates = $approveState::Any
}
$wsus.GetUpdates($updateScope) | ForEach {
    Write-Verbose ("Declining {0}" -f $_.Title) -Verbose
    $_.Decline()
}
}



# Configure Default Approval Rule

if ($DefaultApproval -eq $True)
{
write-host 'Configuring default automatic approval rule'
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$rule = $wsus.GetInstallApprovalRules() | Where {
    $_.Name -eq "Default Automatic Approval Rule"}
$class = $wsus.GetUpdateClassifications() | ? {$_.Title -In (
    'Critical Updates',
    'Definition Updates',
    'Feature Packs',
    'Security Updates',
    'Service Packs',
    'Update Rollups',
    'Updates')}
$class_coll = New-Object Microsoft.UpdateServices.Administration.UpdateClassificationCollection
$class_coll.AddRange($class)
$rule.SetUpdateClassifications($class_coll)
$rule.Enabled = $True
$rule.Save()
}



# Run Default Approval Rule

if ($RunDefaultRule -eq $True)
{
write-host 'Running Default Approval Rule'
write-host ' >This step may timeout, but the rule will be applied and the script will continue' -ForegroundColor Yellow
try {
$Apply = $rule.ApplyRule()
}
catch { 
write-warning $_
}
Finally {
# Cleaning Up TempDir

write-host 'Cleaning temp directory'
if (Test-Path $TempDir\ReportViewer.exe)
{Remove-Item $TempDir\ReportViewer.exe -Force}
if (Test-Path $TempDir\SQLEXPRWT_x64_ENU.exe)
{Remove-Item $TempDir\SQLEXPRWT_x64_ENU.exe -Force}
If ($Tempfolder -eq "No")
{Remove-Item $TempDir -Force}

write-host 'WSUS log files can be found here: %ProgramFiles%\Update Services\LogFiles'
write-host 'Done!' -foregroundcolor Green
}
}

else {
# Cleaning Up TempDir

write-host 'Cleaning temp directory'
if (Test-Path $TempDir\ReportViewer.exe)
{Remove-Item $TempDir\ReportViewer.exe -Force}
if (Test-Path $TempDir\SQLEXPRWT_x64_ENU.exe)
{Remove-Item $TempDir\SQLEXPRWT_x64_ENU.exe -Force}
If ($Tempfolder -eq "No")
{Remove-Item $TempDir -Force}

write-host 'WSUS log files can be found here: %ProgramFiles%\Update Services\LogFiles'
write-host 'Done!' -foregroundcolor Green
}
}

