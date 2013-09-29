$shell = New-Object -ComObject Shell.Application
$programsFolder = $shell.Namespace(23).Self.Path
$vsfolder = $shell.Namespace($programsFolder + "\Microsoft Visual Studio 2012")
$vs2012 = "Visual Studio 2012.lnk"
$vs = @($vs2012)
foreach($_ in $vs){
($vsfolder.ParseName($_).verbs() | ? {$_.Name -match "Tas&kbar"}).Doit()
}

