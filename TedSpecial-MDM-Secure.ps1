# Changes the registry to allow you past Ted's super secure MDM security baseline configurations that destroy the general Powershell vibe
$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client'
$Name         = 'AllowBasic'
$Value        = '00000001'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force