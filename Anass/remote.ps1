#$psVirtualMachine = Add-AzVMNetworkInterface -VM $psVirtualMachine -Id $Nic.Id

#$CreateNewVM = New-AzVM -ResourceGroupName $ResourceGroupName -Location $GeoLocation -VM $psVirtualMachine

#Enter-PSSession -ConnectionUri https://20.55.86.63:5986 -Credential $Cred -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck) -Authentication Negotiate

Enable-PSRemoting -Force
New-NetFirewallRule -Name "Allow WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5986 -Protocol TCP
$thumbprint = (New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My).Thumbprint
$command = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""$env:computername""; CertificateThumbprint=""$thumbprint""}"
cmd.exe /C $command
