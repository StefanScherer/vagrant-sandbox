# http://smsagent.wordpress.com/2014/02/07/installing-and-configuring-wsus-with-powershell/
# http://gallery.technet.microsoft.com/Install-and-Configure-WSUS-006a203a

# open ping for packer-windows builds, this deprecated command even works on 2012 R2
netsh firewall set icmpsetting 8

if (Test-Path 'c:\vagrant\scripts\InstallWSUS.ps1') {
  . c:\vagrant\scripts\InstallWSUS.ps1
} else {
  if (!(Test-Path 'c:\vagrant\resources\InstallWSUS.ps1')) {
    (New-Object Net.WebClient).DownloadFile("http://gallery.technet.microsoft.com/Install-and-Configure-WSUS-006a203a/file/108277/1/InstallWSUS.ps1", 'c:\vagrant\resources\InstallWSUS.ps1')
  }

  . c:\vagrant\resources\InstallWSUS.ps1
}

