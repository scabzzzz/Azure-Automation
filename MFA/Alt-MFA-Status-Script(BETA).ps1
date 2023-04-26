###You must run Powershell in Admin mode to pipe CSV out

$LocalFilePath = "C:\MFAUsers.CSV"

$Report = @()
$i = 0
$Accounts = (Get-MsolUser -All | ? {$_.StrongAuthenticationMethods -ne $Null} | Sort DisplayName)

ForEach ($Account in $Accounts) {
   #Write-Host "Processing" $Account.DisplayName
   $i++
   $Methods = $Account | Select -ExpandProperty StrongAuthenticationMethods
   $MFA = $Account | Select -ExpandProperty StrongAuthenticationUserDetails
   $State = $Account | Select -ExpandProperty StrongAuthenticationRequirements
   Write-Host $i "accounts are MFA-enabled" $Methods $State $MFA
   }

 
#$Report | Export-CSV -NoTypeInformation $LocalFilePath