call cinst golang
call cinst bzr
call cinst hg
set PATH=%PATH%;c:\go\bin
set GOPATH=C:\users\vagrant\go
mkdir %GOPATH%
call cinst git
set PATH=%PATH%;c:\program files (x86)\git\cmd
go get -u github.com/mitchellh/gox
set PATH=%PATH%;%GOPATH%\bin

