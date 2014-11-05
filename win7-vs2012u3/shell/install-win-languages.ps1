# from http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc

# notice: A chocolatey cinst PSWindowsUpdate will also do the trick

function Expand-ZIPFile($file, $destination)
{
$shell = new-object -com shell.application
$zip = $shell.NameSpace($file)
foreach($item in $zip.items())
{
$shell.Namespace($destination).copyhere($item)
}
}

$Userprofile = get-content env:userprofile

if ((Test-Path -Path "$Userprofile\Documents\WindowsPowerShell\Modules\PSWindowsUpdate") -ne $True)
{
  $DownloadUrl = 'http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/41459/28/PSWindowsUpdate.zip'
  $ZipFile = 'c:\vagrant\resources\PSWindowsUpdate.zip'

  "Downloading PSWindowsUpdate.zip"
  (New-Object Net.WebClient).DownloadFile("$DownloadUrl","$ZipFile")

  if ((Test-Path -Path "$Userprofile\Documents\WindowsPowerShell\Modules") -ne $True)
  {
    New-Item -Path "$Userprofile\Documents\WindowsPowerShell\Modules" -ItemType directory
  }
  "Exctracting zip to $Userprofile\Documents\WindowsPowerShell\Modules"
  Expand-ZIPFile -File $ZipFile -Destination "$Userprofile\Documents\WindowsPowerShell\Modules"
}

Import-Module PSWindowsUpdate

# "List all available Windows Updates"
# Get-WUList -MicrosoftUpdate 

"Install some Language Packs"
get-wuinstall -Title "Bulgarian Language Pack" -AcceptAll
get-wuinstall -Title "Danish Language Pack" -AcceptAll
get-wuinstall -Title "German Language Pack" -AcceptAll
get-wuinstall -Title "Spanish Language Pack" -AcceptAll
get-wuinstall -Title "French Language Pack" -AcceptAll
get-wuinstall -Title "Italian Language Pack" -AcceptAll
get-wuinstall -Title "Dutch Language Pack" -AcceptAll
get-wuinstall -Title "Polish Language Pack" -AcceptAll
get-wuinstall -Title "Romanian Language Pack" -AcceptAll

# Arabic Language Pack
# Bulgarian Language Pack
# Chinese (Simplified) Language Pack
# Chinese (Traditional) Language Pack
# Croatian Language Pack
# Czech Language Pack
# Danish Language Pack
# Dutch Language Pack
# Estonian Language Pack
# Finnish Language Pack
# French Language Pack
# German Language Pack
# Greek Language Pack
# Hebrew Language Pack
# Hungarian Language Pack
# Italian Language Pack
# Japanese Language Pack
# Korean Language Pack
# Latvian Language Pack
# Lithuanian Language Pack
# Norwegian Language Pack
# Polish Language Pack
# Portuguese (Brazil) Language Pack
# Portuguese (Portugal) Language Pack
# Romanian Language Pack
# Russian Language Pack
# Serbian (Latin) Language Pack
# Slovak Language Pack
# Slovenian Language Pack
# Spanish Language Pack
# Swedish Language Pack
# Thai Language Pack
# Turkish Language Pack
# Ukrainian Language Pack
