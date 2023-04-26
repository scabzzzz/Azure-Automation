################################## Import ActiveDirectory ##############################################

Import-Module ActiveDirectory

########################################################################################################

Clear-host

Write-host "The following setup procedure will build an Active Directory Account, appropriate AD permissions, Office365 mailbox, and Office365 license."

#Identifies user permissions to copy.
    do {
$nameds = Read-Host “Copy Permissions From Username (i.e. firstinitiallastname)”
if (dsquery user -samid $nameds){“AD Found”}

elseif ($nameds = “null”) {“AD User not Found”}
}
while ($nameds -eq “null”)

#Checks if the new user exists.

write-host "Check for existing user"

do {

$NewUserds = Read-Host “Enter New Username (i.e. firstinitiallastname)”

While ( $NewUserds -eq “” ) { $NewUserds = Read-Host “Enter New”}
$NewUser = $Newuserds
    
if (dsquery user -samid $NewUserds){“Ad User Exist”}

elseif ($NewUserds = “no”) {“Validation OK”}
}

while ($Newuserds -ne “no”)
        
# Gets all of the users info to be copied to the new account.

$name = Get-ADUser -Identity $nameds -Properties *

$DN = $name.distinguishedName
$OldUser = [ADSI]“LDAP://$DN”
$Parent = $OldUser.Parent
$OU = [ADSI]$Parent
$OUDN = $OU.distinguishedName
$Firstinitial = Read-Host "First Initial"
$Firstname = Read-Host “First Name”
$Lastname = Read-Host “Last Name”
$NewName = "$Firstname $Lastname"
$NewUser = “$Firstinitial$Lastname”
$domain = "applyists.com" 

# Creates the user from the copied properties.

New-ADUser -SamAccountName $NewUser -Name $NewName -GivenName $firstname -Surname $lastname -Instance $DN -Path “$OUDN” -AccountPassword (Read-Host “New Password” -AsSecureString) –userPrincipalName $NewUser@$domain -email $NewUser@$domain -Company $name.Company -Department $name.Department -Manager $name.Manager -title $name.Title -Office $name.Office -City $name.city -PostalCode $name.postalcode -Country $name.country -OfficePhone $name.OfficePhone -Fax $name.fax -State $name.State -StreetAddress $name.StreetAddress -Enabled $true

Set-ADUser -Identity $NewUser -ChangePasswordatLogon $false

Set-ADUser -Identity $NewUser -ScriptPath "mapping.bat"

# Gets groups from the copied user and populates the new user in them.

write-host “Copying Group Membership”

$groups = (GET-ADUSER –Identity $name –Properties MemberOf).MemberOf
foreach ($group in $groups) {

Add-ADGroupMember -Identity $group -Members $NewUser
}
$count = $groups.countT

# Provides time needed for AD permissions to build out in Exchange.

write-host “Please wait while AD applies permissions”

Start-Sleep -s 15

Clear-host

# Runs Azure Synchronization Service on ServerName

Invoke-Command -ComputerName ISTS-Utility {Start-ADSyncSyncCycle -PolicyType Delta}

# Provides time need to sync between on-premise ServerName and Office365 cloud server

write-host "Please wait 30 minutes to allow for Azure Ad Sync and log into the Office365 web portal to apply Office365 license."

Start-Sleep 60