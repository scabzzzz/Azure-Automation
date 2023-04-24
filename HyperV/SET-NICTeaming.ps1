#Cmdlets to configure LBFO NIC teaming in Windows Server 2022 over SET. 
#Set NIC teams dont work the same as LBFO teams. SET used as a replacement but we dont want that
#MS article that describes this - https://learn.microsoft.com/en-us/powershell/module/hyper-v/new-vmswitch?view=windowsserver2022-ps

#set variables for NIC and Team names
$TeamName='your_team_name'
$VMSwitch='your_switch_name'
New-VMSwitch -AllowNetLbfoTeams $true -NetAdapterName $TeamName -Name $VMSwitch' -AllowManagementOS
