"Pin Qt Creator to taskbar"
$shell = New-Object -ComObject Shell.Application
$programsFolder = $shell.Namespace(2).Self.Path

$qtfolder = $shell.Namespace($programsFolder + "\Qt Enterprise " + $($args[0]) + "\")
$lnk = "Qt Creator.lnk"
$i = @($lnk)
foreach($_ in $i){
($qtfolder.ParseName($_).verbs() | ? {$_.Name -match "Tas&kbar"}).Doit()
}

