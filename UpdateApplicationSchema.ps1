param(
    [Parameter(Mandatory=$true)]
    [string]$ClientId,
    [Parameter(Mandatory=$true)]
    [string]$ClientSecret,
    [Parameter(Mandatory=$true)]
    [string]$ServicePrincipalId,
    [Parameter(Mandatory=$true)]
    [string]$TenantId
)
#$ClientSecret = Get-Secret -Name 'APIClientSecret'
#$ClientID =  'b399e0c8-644e-4a1f-b195-9b93de247909'
$ClientSecretCredential = New-Object System.Management.Automation.PSCredential ($ClientID, $ClientSecret)
$csv2scimParams = @{
    Path = '.\EmployeeList.csv'
    UpdateSchema = $true
    ServicePrincipalId = $servicePrincipalId # 'e49999e2-05b0-4f63-a518-c9a04ec16589'
    TenantId =  $TenantId #'58264fae-2f34-4dc4-9500-c860b7d7aec6'
    ScimSchemaNamespace = "urn:ietf:params:scim:schemas:extension:suryendub:1.0:User"
    ClientSecretCredential = $ClientSecretCredential
}
.\CSV2SCIM.ps1 @csv2scimParams -Debug

