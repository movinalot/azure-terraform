Write-Host "Enable HTTPS in WinRM"
$WinRmHttps = "@{Hostname=`"$RemoteHostName`"; CertificateThumbprint=`"$Thumbprint`"}"
winrm create winrm/config/Listener?Address=*+Transport=HTTPS $WinRmHttps

Write-Host "Set Basic Auth in WinRM"
$WinRmBasic = "@{Basic=`"true`"}"
winrm set winrm/config/service/Auth $WinRmBasic 

Write-Host "Open Firewall Ports"
netsh advfirewall firewall add rule name="Windows Remote Management (HTTP-In)" dir=in action=allow protocol=TCP localport=5985

netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986

$Path = $env:TEMP
$Installer = "chrome_installer.exe"
Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile "$Path\$Installer"
Start-Process -FilePath "$Path\$Installer" -Args "/silent /install" -Verb RunAs -Wait
Remove-Item "$Path\$Installer"