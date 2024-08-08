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

$ClientSecretCredential = New-Object System.Management.Automation.PSCredential ($ClientID, $ClientSecret)
$csv2scimParams = @{
    Path = '.\EmployeeList.csv'
    UpdateSchema = $true
    ServicePrincipalId = $servicePrincipalId # 
    TenantId =  $TenantId #
    ScimSchemaNamespace = "urn:ietf:params:scim:schemas:extension:suryendub:1.0:User"
    ClientSecretCredential = $ClientSecretCredential
}
.\CSV2SCIM.ps1 @csv2scimParams -Debug

