$ClientSecret = Get-Secret -Name 'APIClientSecret'
$ClientID =  'b399e0c8-644e-4a1f-b195-9b93de247909'
$ClientSecretCredential = New-Object System.Management.Automation.PSCredential ($ClientID, $ClientSecret)

$csv2scimParamsSendAPI = @{
    Path = '.\EmployeeList.csv'
    AttributeMapping = Import-PowerShellDataFile '.\AttributeMapping.psd1'
    ServicePrincipalId = 'e49999e2-05b0-4f63-a518-c9a04ec16589'
    TenantId = '58264fae-2f34-4dc4-9500-c860b7d7aec6'
    ClientSecretCredential = $ClientSecretCredential
    
}

.\PowerShell\CSV2SCIM\src\CSV2SCIM.ps1 @csv2scimParamsSendAPI
