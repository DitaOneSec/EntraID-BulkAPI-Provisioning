$AttributeMapping = @{
    'externalId' = 'employeeId'
    'id' = 'objectId'
    'active' = 'IsSoftDeleted'
    'displayName' = 'displayName'
    'userName' = 'userPrincipalName'
    'nickName' = 'mailNickname'
    'userType' = 'extensionAttribute14'
    'title' = 'Puesto'
    'addresses' = @(
        @{
            'type'          = 'work'
            'streetAddress' = 'physicalDeliveryOfficeName'
            'formatted'     = 'physicalDeliveryOfficeName'
        }
    )
    'phoneNumbers' = @(
        @{
            'type'  = 'work'
            'value' = 'telephoneNumber'
        }
        @{
            'type'  = 'mobile'
            'value' = 'mobile'
        }
        @{
            'type'  = 'fax'
            'value' = 'facsimileTelephoneNumber'
        }
    )
    'emails' = @(
        @{
            'type'  = 'work'
            'value' = 'mail'
        }
    )
    'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User' = @{
        'department' = 'department'
        'manager' = @{
            'value' = 'manager'
        }
    }
    'name' = @{
        'familyName' = 'surname'
        'givenName'  = 'givenName'
    }
    'preferredLanguage' = 'preferredLanguage'
}
