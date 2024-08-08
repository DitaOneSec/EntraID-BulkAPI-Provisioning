@{
    externalId  = 'id'
    name        = @{
        familyName = 'last_name'
        givenName  = 'first_name'
    }
    active      = { $_.'estatus_póliza_sgmm_' -eq 'Active' }
    userName    = 'email'
    displayName = "$($_.'first_name') $($_.'last_name')"
    nickName    = 'email'
    userType    = 'tipo'
    title       = 'carrera'
    addresses   = @(
        @{
            type          = 'work'
            streetAddress = "$($_.'calle') $_.'no._ext' $_.'no._int'"
            locality      = 'delegación_o_municipio'
            postalCode    = 'código_postal'
            country       = 'entidad_federativa'
        }
    )
    phoneNumbers = @(
        @{
            type  = 'work'
            value = 'teléfono_celular'
        },
        @{
            type  = 'emergency'
            value = 'número_de_emergencia'
        }
    )
    "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User" = @{
        employeeNumber        = 'id'
        costCenter            = 'costo'
        organization          = 'patrón'
        division              = 'tipo_de_membresia'
        department            = 'carrera'
        clabeInterbancaria    = 'clabe_interbancaria_18_dig'
        cuentaBancaria        = 'cuenta_bancaria'
        curp                 = 'curp'
        rfc                  = 'rfc'
        nss                  = 'nss'
        cédulaProfesional    = 'cédula_profesional'
        nombreDelBanco       = 'nombre_del_banco'
        birthday             = 'birthday'
        emailPersonal        = 'email_personal'
        equipoAsignado       = 'equipo_asignado'
        time_zone            = 'time_zone'
        last_login_at        = 'last_login_at'
        joined_at            = 'joined_at'
        left_at              = 'left_at'
        sexo                 = 'sexo'
        colonia              = 'colonia'
    }
}