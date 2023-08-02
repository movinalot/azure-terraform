Write-Host "Enable HTTPS in WinRM"
$WinRmHttps = "@{Hostname=`"$RemoteHostName`"; CertificateThumbprint=`"$Thumbprint`"}"
winrm create winrm/config/Listener?Address=*+Transport=HTTPS $WinRmHttps

Write-Host "Set Basic Auth in WinRM"
$WinRmBasic = "@{Basic=`"true`"}"
winrm set winrm/config/service/Auth $WinRmBasic 

Write-Host "Open Firewall Ports"
netsh advfirewall firewall add ruleenter code here name="Windows Remote Management (HTTP-In)" dir=in action=allow protocol=TCP localport=5985

netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986

Disable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6
Invoke-WebRequest "https://fortinetcloudinttraining.blob.core.windows.net/files-staging/7z2301-x64.exe" -UseBasicParsing -OutFile 7z2301-x64.exe
Move-Item 7z2301-x64.exe C:/Users/Public/Documents/7z2301-x64.exe
