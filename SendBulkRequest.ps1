$ClientSecret = Get-Secret -Name 'APIClientSecret'
$ClientID =  '6eba9bee-8dfb-49ce-9710-1ca5cce5c495'
$ClientSecretCredential = New-Object System.Management.Automation.PSCredential ($ClientID, $ClientSecret)

$csv2scimParamsSendAPI = @{
    Path = '.Samples\csv-with-2-records.csv'
    AttributeMapping = '.\AttributeMapping.psd1'
    ServicePrincipalId = 'c8fb7659-9f63-4034-b923-86fe0e5e966e'
    TenantId = 'adad4a7c-ddab-4782-9aeb-75be5f5523fa'
    ClientSecretCredential = $ClientSecretCredential
    
}

.\PowerShell\CSV2SCIM\src\CSV2SCIM.ps1 @csv2scimParamsSendAPI
