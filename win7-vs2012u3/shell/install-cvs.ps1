# from http://www.howtogeek.com/tips/how-to-extract-zip-files-using-powershell/
function Expand-ZIPFile($file, $destination) {
  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)
  foreach($item in $zip.items()) {
    # overwrite target files with 0x14, from http://stackoverflow.com/questions/2359372/how-do-i-overwrite-existing-items-with-folder-copyhere-in-powershell
    $shell.Namespace($destination).copyhere($item, 0x14)
  }
}

$destdir = "c:\windows\system32"
$exe = $destdir + "\cvs.exe"

if (!(Test-Path $exe)) {
  $zip = $env:TEMP + "\cvs-1-11-22.zip"
  Write-Host "Downloading cvs-1-11-22.zip"
  (New-Object Net.WebClient).DownloadFile('http://ftp.gnu.org/non-gnu/cvs/binary/stable/x86-woe/cvs-1-11-22.zip', $zip)
  Write-Host "Expanding cvs-1-11-22.zip"
  Expand-ZIPFile -File $zip -Destination $destdir
}

