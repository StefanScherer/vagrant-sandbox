"Pin Chrome to taskbar"
$shell = New-Object -ComObject Shell.Application
$programsFolder = $shell.Namespace(23).Self.Path

$vsfolder = $shell.Namespace($programsFolder + "\Google Chrome\")
$chrome = "Google Chrome.lnk"
$vs = @($chrome)
foreach($_ in $vs){
($vsfolder.ParseName($_).verbs() | ? {$_.Name -match "Tas&kbar"}).Doit()
}

