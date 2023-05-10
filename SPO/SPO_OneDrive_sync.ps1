#Mapping OneDrive shortcuts via Powershell. Read source below as its tricky and requires app registration for SPO App
#Discussion found here https://techcommunity.microsoft.com/t5/onedrive-for-business/programmatic-way-to-add-a-shortcut-to-onedrive-for-users/m-p/1886184


$UPN = "upn@domain.com"
$Token = (Get-MsalToken -TenantId tenantID -ClientId ClientID -ClientCertificate (get-item Cert:\LocalMachine\My\CertThumbprint) -scopes "https://yourtenant-my.sharepoint.com/.default").AccessToken
$URI = "https://yourtenant-my.sharepoint.com/_api/v2.1/drives/$UPN/items/root/children"

$Dokumenty = @(
    @{Site1 = @"
{"name":"Documents","remoteItem":{"sharepointIds":{"listId":"listID","listItemUniqueId":"root","siteId":"SiteID","siteUrl":"https://yourtenant.sharepoint.com/sites/SiteName","webId":"32bf89e7-ae22-4d67-8444-698ed19421e7"}},"@microsoft.graph.conflictBehavior":"rename"}
"@},
    @{Site2 = @"
{"name":"Documents","remoteItem":{"sharepointIds":{"listId":"listID","listItemUniqueId":"root","siteId":"SiteID","siteUrl":"https://yourtenant.sharepoint.com/sites/SiteName","webId":"32bf89e7-ae22-4d67-8444-698ed19421e7"}},"@microsoft.graph.conflictBehavior":"rename"}
"@},
    @{Site3 = @"
{"name":"Documents","remoteItem":{"sharepointIds":{"listId":"listID","listItemUniqueId":"root","siteId":"SiteID","siteUrl":"https://yourtenant.sharepoint.com/sites/SiteName","webId":"32bf89e7-ae22-4d67-8444-698ed19421e7"}},"@microsoft.graph.conflictBehavior":"rename"}
"@}
)

$Dokumenty | ForEach-Object { Invoke-RestMethod -Uri $URI -Headers @{Authorization = "Bearer $Token"} -ContentType 'application/json' -Body $_.values -Method POST}