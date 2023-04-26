#Uninstalls the full suite of Mitel apps
$app = Get-WmiObject Win32_Product -ComputerName $env:COMPUTERNAME | where { $_.name -eq "Mitel Connect" }
$app.Uninstall()
$app = Get-WmiObject Win32_Product -ComputerName $env:COMPUTERNAME | where { $_.name -eq "Mitel Presenter" }
$app.Uninstall()
$app = Get-WmiObject Win32_Product -ComputerName $env:COMPUTERNAME | where { $_.name -eq "Mitel Teamwork" }
$app.Uninstall()