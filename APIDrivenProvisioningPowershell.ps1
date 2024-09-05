#Parameter block with APIKey string Parameter
param(
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true)]
    [string]$ClientId,
    [Parameter(Mandatory=$true)]
    [string]$ClientSecret,
    [Parameter(Mandatory=$true)]
    [string]$ServicePrincipalId,
    [Parameter(Mandatory=$true)]
    [string]$TenantId,
    [Parameter(Mandatory=$true)]
    [string]$Subdomain

    

)

function Remove-Diacritics {
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $String
    )
    process {
        [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
    }
}

$Uri = "https://onesec-test.bizneohr.com/api/v1/users"
$headers=@{}
$headers.Add("content-type", "application/json")
$APIKey = Get-Secret -Name API_KEY -AsPlainText
$credObject = New-Object System.Management.Automation.PSCredential ($APIKey, ("RandomValue" | ConvertTo-SecureString -AsPlainText -Force))
$headers=@{}
$headers.Add("content-type", "application/json")

$fields = @("id",
"email",
"external_id",
    "first_name",
    "last_name",
    "division",
    "work_contracts.end_at",
    "work_contracts.start_at",
    "work_contracts.fte",
    "main_taxons")
$body = @{
    fields = $fields
} | ConvertTo-Json


$response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $headers -ContentType 'application/json' -Body $body -Authentication Basic -Credential $credObject
$employees = $response.employees 

$ScimPayloadOutputResults = foreach ($user in $employees) {
    

    #Define UserID & SamAccountName values
    $UserID = $($user.displayName) -replace ' ','.'
    $UserID = $UserID | Remove-Diacritics
    $UserID = $UserID -replace "['´`~:;><,{}?/\|()_=+]",""
    
    
    #Define UserType Value
    # $UserType = if ($user.department -ne "Subcontractors") {
    #     "Employee"
    # } else {
    #     "Subcontractor"
    # }
    
    # $HireDate = if ($user.HireDate) { 
    #     Get-Date $($user.HireDate) -Format 'yyyy-MM-ddTHH:mm:ssZ'
    # } else {
    #     ''
    # }
    
    # $LeaveDate = if ($user.terminationDate -ne '0000-00-00') {
    #     Get-Date $($user.terminationDate) -Format 'yyyy-MM-ddTHH:mm:ssZ'
    # } else {
    #     ''
    # }
    
    # $WorkerStatus = if ($user.terminationDate -ne '0000-00-00') {
    #     'Inactive'
    # } else {
    #     'Active'
    # }
    
    # Crear el payload SCIM
    $ScimBulkPayload = @()
    foreach ($user in $CsvData) {
        $scimRecord = @{
            schemas = @(
                "urn:ietf:params:scim:schemas:core:2.0:User",
                "urn:ietf:params:scim:schemas:extension:onesec:2.0:User"
            )
            id                = $user.objectId
            userName          = $user.userPrincipalName
            emails            = @(@{ type = "work"; value = $user.email })
            externalId        = $user.externalId
            name = @{
                givenName  = $user.first_name
                familyName = $user.last_name
            }
            "urn:ietf:params:scim:schemas:extension:onesec:2.0:User" = @{
                joined_at = $user."work_contracts.start_at"
                left_at   = $user."work_contracts.end_at"
                sexo      = $user.sexo
                work_contracts = @{
                    fte = $user."work_contracts.fte"
                }
                main_taxons = $user.main_taxons
            }
        }
        
        $ScimBulkPayload += $scimRecord
    }
     
    
    

    #Build array for output
    [PSCustomObject]@{
        employeeId      = $user.external_id
        objectId        = $user.id
        IsSoftDeleted   = $user.active
        department      = $user.department
        displayName     = $user.displayName
        givenName       = $user.first_name
        jobTitle        = $user.title
        mail            = $user.email
        manager         = $user.manager
        mobile          = $user.mobile
        preferredLanguage = $user.preferredLanguage
        surname         = $user.last_name
        telephoneNumber = $user.workPhone
        userPrincipalName = "$($user.userName)@DefaultDomain()" 
        
    }
}

$ScimPayloadOutputResults | Export-Csv -Path 'EmployeeList.csv' 
$ClientSecretCredential = New-Object System.Management.Automation.PSCredential ($ClientID, ($ClientSecret | ConvertTo-SecureString -AsPlainText -Force))

$csv2scimParamsSendAPI = @{
    Path = '.\Samples\csv-with-2-records.csv'
    AttributeMapping = Import-PowerShellDataFile '.\Samples\csv-with-2-records.csv'
    ServicePrincipalId = $ServicePrincipalId
    TenantId = $TenantId
    ClientSecretCredential = $ClientSecretCredential
    
}
.\CSV2SCIM.ps1 @csv2scimParamsSendAPI
