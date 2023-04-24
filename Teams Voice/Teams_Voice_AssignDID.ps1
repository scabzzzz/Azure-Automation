#Please see the ReadMe document for supplementary information before starting this script
#YOU MUST CONNECT TO THE TEAMS MODULE AS WELL AS THE MSOLSERVICE MODULE OTHERWISE THE SCRIPT WILL NOT COMPLETE SUCCESSFULLY
#Connect-MicrosoftTeams and Connect-MSOLService
Add-Type -AssemblyName System.Windows.Forms

#Open file dialog
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'Comma-separated values (*.csv)|*.csv'
}

$Null = $FileBrowser.ShowDialog()

$users = Import-csv $FileBrowser.filename

#Regular expression to compare DID and check format (10 digit, no spaces or punctuation)
[regex]$didFormat='^\d{10}$'
[regex]$extFormat='^\d{4,6}$'

#Iterate through users
ForEach($User in $Users) {

    #Validate that email, phone number and location are set
    if (!$user.Email -or !$user.DID -or !$user.LocationID) {

        Write-Host "****Information for $($user.FirstName) $($user.LastName) is incomplete****"

        } 

    #Validate number is in 10 digit format with no spaces or dashes
    elseif(!($user.DID -match $didFormat)) {

        Write-Host "$($user.FirstName) $($user.LastName)'s DID needs to be in 1234567890 format"

        }
        
    #Passed input validation -- assign phone number through Teams and assign phone number/extension in Azure AD     
    else {

        Write-Host "Processing $($user.FirstName) $($user.LastName)"
        Set-CsOnlineVoiceUser -Identity $($User.Email) -TelephoneNumber +1$($User.DID) -LocationID $($User.LocationID)

        #Validate extension format
        if ($user.Extension -match $extFormat) {
            
            Write-Host "Adding extension for $($user.FirstName) $($user.LastName)"
            Set-MsolUser -UserPrincipalName $($User.Email) -PhoneNumber +1$($User.DID)x$($User.Extension)

            }
        else {
            
            Write-Host "Extension not added for $($user.FirstName) $($user.LastName) (needs to be 4-6 digits)"
        
        }

    }
    
}



