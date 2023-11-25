#Parameter block with APIKey string Parameter
param(
    [Parameter(Mandatory=$true)]
    [string]$APIKey,
    [Parameter(Mandatory=$true)]
    [string]$ClientSecret
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
#$APIKey = Get-Secret -Name BambooAPIKey -AsPlainText
# Add an Example Block
<#
$APIKey = Get-Secret -Name BambooAPIKey -AsPlainText
$ClientSecret = Get-Secret -Name 'APIClientSecret'
.\APIDrivenProvisioningPowershell.ps1 -APIKey $APIKey -ClientSecret $ClientSecret

#>
$Uri = 'https://api.bamboohr.com/api/gateway.php/mimnbeyond/v1/reports/custom?format=JSON&onlyCurrent=false'
$headers=@{}
$headers.Add("content-type", "application/json")
#$APIKey = Get-Secret -Name BambooAPIKey -AsPlainText
$credObject = New-Object System.Management.Automation.PSCredential ($APIKey, ("RandomValue" | ConvertTo-SecureString -AsPlainText -Force))
$headers=@{}
$headers.Add("content-type", "application/json")

$fields = @("DisplayName",
"LastName",
"middleName",
    "JobTitle",
    "Department",
    "division",
    "supervisorEid",
    "Country",
    "location",
    "homeEmail",
    "mobilePhone",
    "workPhone",
    "hireDate",
    "terminationDate")
$body = @{
    fields = $fields
} | ConvertTo-Json

$headers=@{}
$headers.Add("content-type", "application/json")
$response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $headers -ContentType 'application/json' -Body $body -Authentication Basic -Credential $credObject
$employees = $response.employees 

$ScimPayloadOutputResults = foreach ($user in $employees) {
    

    #Define UserID & SamAccountName values
    $UserID = $($user.displayName) -replace ' ','.'
    $UserID = $UserID | Remove-Diacritics
    $UserID = $UserID -replace "['´`~:;><,{}?/\|()_=+]",""
    
    
    #Define UserType Value
    $UserType = if ($user.department -ne "Subcontractors") {
        "Employee"
    }
    Else {
        "Subcontractor"
    }
     $HireDate = Get-Date $($user.HireDate) -Format 'yyyy-MM-ddTHH:mm:ssZ'
     $LeaveDate = ''
     $WorkerStatus = 'Active'
     if($($user.terminationDate) -ne '0000-00-00')
     {
        $WorkerStatus = 'Inactive'
        $LeaveDate = Get-Date $($user.terminationDate) -Format 'yyyy-MM-ddTHH:mm:ssZ'
     }

     
    
    

    #Build array for output
    [PSCustomObject]@{
        WorkerID  = $user.id
        WorkerStatus = $WorkerStatus
        WorkerType  = $UserType
        FirstName = $user.firstname
        LastName = $user.lastname
        FullName = $user.displayname
        UserID = $UserID
        Email = $Email
        ManagerID = $user.supervisorEid
        HireDate = $HireDate
        LeaveDate = $LeaveDate
        Department = $user.Department
        JobTitle = $user.jobtitle
        MobilePhone = $user.mobilePhone
        OfficePhone = $user.workPhone
        
    }
}

$ScimPayloadOutputResults | Export-Csv -Path 'EmployeeList.csv' 
$ClientSecret = Get-Secret -Name 'APIClientSecret' -AsPlainText
$ClientID =  'b399e0c8-644e-4a1f-b195-9b93de247909'

$ClientSecretCredential = New-Object System.Management.Automation.PSCredential ($ClientID, ($ClientSecret | ConvertTo-SecureString -AsPlainText -Force))

$csv2scimParamsSendAPI = @{
    Path = '.\EmployeeList.csv'
    AttributeMapping = Import-PowerShellDataFile '.\AttributeMapping.psd1'
    ServicePrincipalId = 'e49999e2-05b0-4f63-a518-c9a04ec16589'
    TenantId = '58264fae-2f34-4dc4-9500-c860b7d7aec6'
    ClientSecretCredential = $ClientSecretCredential
    
}
.\CSV2SCIM.ps1 @csv2scimParamsSendAPI
