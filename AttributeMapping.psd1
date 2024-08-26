$AttributeMapping = @{
    'externalId' = 'employeeId'
    'name' = @{
        'familyName' = 'last_name'
        'givenName'  = 'first_name'
    }
    'active' = 'accountEnabled'
    'displayName' = 'displayName'
    'userName' = 'userPrincipalName'
    'nickName' = 'userPrincipalName'
    'userType' = 'extensionAttribute14'
    'title' = 'jobTitle'
    'addresses' = @(
        @{
            'type'          = 'work'
            'streetAddress' = 'physicalDeliveryOfficeName'
            'locality'      = 'region'
            'postalCode'    = 'postalCode'
            'country'       = 'country'
            'region'        = 'region'
        }
    )
    'phoneNumbers' = @(
        @{
            'type'  = 'work'
            'value' = 'telephoneNumber'
        }
        @{
            'type'  = 'mobile'
            'value' = 'cellphone'
        }
    )
    'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User' = @{
        'employeeNumber' = 'employeeId'
        'department'     = 'department'
        'manager'        = @{
            'value' = 'manager'
        }
    }
    'urn:ietf:params:scim:schemas:extension:onesec:1.0:User' = @{
        'hiredate'       = 'employeeHireDate'
        'leavedate'      = 'employeeLeaveDateTime'
        'templeave'      = 'extensionAttribute9'
        'pronouns'       = 'extensionAttribute10'
        'usagelocation'  = 'access'
    }
}
