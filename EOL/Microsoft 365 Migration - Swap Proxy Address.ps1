<## Based on original script found here: https://community.spiceworks.com/topic/1263774-exchange-bulk-switch-alias-and-primary-emails
Original credit goes to SigKill on Spiceworks forum
Disabled user support added by System I.T on Spiceworks forum

This has been updated by Kurt Kuszek 3/2017

No Liability is assumed, ALWAYS test before using in production and read the code first!


Changes:
code added to allow flipping back and forth between new/old. Previous script only worked 1 way without a failback.
Also allowed for adding secondary address without changing primary
Cleaned up variables at script termination

Known issues:
Users with difference in name capitalization sometimes error. Be sure to scroll back and look for success on all users on a test VM first!

Next refinement should be proper error handling/logging especially for bigger migrations
##>

$olddomain = "@olddomain.com"
$newdomain = "@newdomain.com"
$makealias = $true
$userou = 'OU=Test,DC=domain,DC=local'
$users = Get-ADUser -Filter * -SearchBase $userou -Properties SamAccountName, EmailAddress, ProxyAddresses
Foreach ($user in $users) {
    $oldemail = "$($user.samaccountname)$($olddomain)"
    $newemail = "$($user.samaccountname)$($newdomain)"
    Write-Host "User: $($user.samaccountname)`n------------------------"d

    #Update Mail Attribute    
    If ($user.EmailAddress -ieq $oldemail) {
        Write-Host "Mail Attribute: Old Value Detected Updating..."
        Write-Host "Old Value: $($user.EmailAddress)"
        $user.EmailAddress = $newemail
        Write-Host "New Value: $($newemail)"
    }
    Elseif ($user.EmailAddress -ieq "$newemail") {
        Write-Host "Mail Attribute: New Value Detected Skipping..."
        Write-Host "Value: $($user.EmailAddress)"
    }
    Else {
        Write-Host "Mail Attribute: Unknown Value Detected NOT Updating..."
        Write-Host "Value: $($user.EmailAddress)"
    }

    #Update ProxyAddresses Attribute
    $blnPrimaryOld = $false
    $blnPrimaryNew = $false
    $blnPrimaryOther = $false
    $blnAliasOld = $false
    $blnAliasNew = $false
    ForEach ($proxy in $user.ProxyAddresses) {
        If ($proxy.StartsWith("SMTP:")) {
            If ($proxy -eq "SMTP:$($oldemail)") {
                $blnPrimaryOld = $true
            }
            Elseif ($proxy -eq "SMTP:$($newemail)") {
                $blnPrimaryNew = $true
            }
            Else {
                $blnPrimaryOther = $true
            }
        }
        ElseIf ($proxy.StartsWith("smtp:")) {
            If ($proxy -eq "smtp:$($oldemail)") {                
                $blnAliasOld = $true
            }
            Elseif ($proxy -eq "smtp:$($newemail)") { 
                $blnAliasNew = $true
            }
        }
    }
	If (($blnPrimaryOld -eq $true) -AND ($blnPrimaryNew -eq $false) -AND ($blnPrimaryOther -eq $false)) {
        Write-Host "Primary Email: Old Value Detected Updating..."
        Write-Host "Removing SMTP:$($oldemail)"
        $user.ProxyAddresses.remove("SMTP:$($oldemail)")
		If ($blnAliasNew -eq $true) {
			Write-Host "Primary Email already exists as Alias. Removing conflict first..."
			Write-Host "Removing smtp:$($newemail)"
			$user.ProxyAddresses.remove("smtp:$($newemail)")		
		}
        Write-Host "Adding SMTP:$($newemail)"
        $user.ProxyAddresses.add("SMTP:$($newemail)")
    }
    Elseif (($blnPrimaryNew -eq $true) -AND ($blnPrimaryOld -eq $false) -AND ($blnPrimaryOther -eq $false)) {
        Write-Host "Primary Email: New Value Detected Skipping..."
    }
    Else {
        Write-Host "Primary Email: Unknown Value Detected NOT Updating..."
    }

    If (($makealias -eq $true) -AND ($blnAliasOld -eq $false)) {
			Write-Host "Making Old Email Alias: $($makealias)"                
            Write-Host "smtp:$($oldemail)"  
            $user.ProxyAddresses.add("smtp:$($oldemail)")
        }

    #Write Values to User
    Write-Host "Setting Values..."
    $result = Set-ADUser -Instance $user
    Write-Host "`n"
}

Remove-Variable $blnAliasOld -ErrorAction SilentlyContinue
Remove-Variable $blnAliasnew -ErrorAction SilentlyContinue
Remove-Variable $makealias -ErrorAction SilentlyContinue
Remove-Variable $oldemail -ErrorAction SilentlyContinue
Remove-Variable $newemail -ErrorAction SilentlyContinue
Remove-Variable $blnPrimaryOld -ErrorAction SilentlyContinue
Remove-Variable $blnPrimarynew -ErrorAction SilentlyContinue
Remove-Variable $olddomain -ErrorAction SilentlyContinue
Remove-Variable $newdomain -ErrorAction SilentlyContinue
Remove-Variable $UserOU -ErrorAction SilentlyContinue
Remove-Variable $users -ErrorAction SilentlyContinue
Write-Host "Le Fin! Be sure to check above for success on every user!"