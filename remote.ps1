$hostname = $env:computername
$isRunningService = (Get-Service winrm).Status -eq "Running"
if (-not ($isRunningService -eq $true)) {
  Write-Host "Starting WinRM service..."
  Start-Service winrm
}
Write-Host "Generating self-signed SSL certificate..."
$certificateThumbprint = (New-SelfSignedCertificate -DnsName "${hostname}" -CertStoreLocation Cert:\LocalMachine\My).Thumbprint
Write-Host "Configuring WinRM to listen on HTTPS..."
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"${hostname}`"; CertificateThumbprint=`"${certificateThumbprint}`"}"
Write-Host "Updating firewall..."
netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986
New-Item -Path 'C:\Script\' -ItemType Directory
# Source file location
$source = 'https://raw.githubusercontent.com/Help4InfoCR430/CR430DEV01/main/CIS_WinSrv2019.ps1'
# Destination to save the file
$destination = 'c:\script\CIS_WinSrv2019.ps1'
#Download the file
Invoke-WebRequest -Uri $source -OutFile $destination

