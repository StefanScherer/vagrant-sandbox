# wsus

Spin up a WSUS server running on Windows 2012 R2 with SQL Express 2012.

## Server

```
vagrant up
```

## Client

In all clients set registry key `hklm\Software\Policies\Microsoft\Windows\WindowsUpdate` to `http://172.16.32.2:8530`

Further reading

* http://smsagent.wordpress.com/2014/02/07/installing-and-configuring-wsus-with-powershell/
* http://www.wsus.de/wsusreg
* https://blog.bartlweb.net/2010/03/wsus-ohne-activedirectory-konfigurieren/
