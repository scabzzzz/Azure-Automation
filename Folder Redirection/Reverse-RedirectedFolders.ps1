#Resets redirected folder values back to default in a really aggressive way.
#Warning! No files will be present any longer, and will be stored wherever they originally were like a server.
#Its best to use gpo to revert back first. If that doesnt work, manually migrate via SPMT or similiar to OneDrive

$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\'
Set-Location $RegistryPath
Set-ItemProperty . Desktop "%USERPROFILE%\Desktop"
Set-ItemProperty . Personal "%USERPROFILE%\Documents"
Set-ItemProperty . 'My Pictures' "%USERPROFILE%\Pictures"