# Sets all user's UPNs under the "SearchBase" to their email field or mail attribute. Make a backup of user's UPNs before running.

foreach ($user in (Get-ADUser -Filter * -SearchBase "OU=Users,DC=company,DC=local")) {

	# Grab the primary Email address field/Mail Attribute
	$newUPN = (Get-Aduser $user -Properties Mail).mail

	# Update the user with their new UPN
	Set-ADUser $user -UserPrincipalName $newUPN

}