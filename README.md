# Bamboo HR API Driven Provisioning to Entra ID

This GitHub Action allows you to provision Entra ID from Bamboo HR using the Bamboo API.

## Inputs

- `bamboo_api_key` (required): The Bamboo API Key.
- `bamboo_subdomain` (required): The Bamboo Subdomain.
- `client_id` (required): The Entra ID Client ID.
- `client_secret` (required): The Entra ID Client Secret.
- `serviceprincipalid` (required): The Entra ID Service Principal ID.
- `tenantid` (required): The Entra ID Tenant ID.

## Usage

To use this action, add the following step to your workflow file:

```yaml
    steps:
    - uses: SuryenduB/EntraID-BulkAPI-Provisioning@main
      with:
        bamboo_api_key:
            ${{ secrets.BAMBOO_API_KEY }}
        bamboo_subdomain:
            ${{ secrets.BAMBOO_SUBDOMAIN }}
        client_id:
            ${{ secrets.CLIENT_ID }}
        client_secret:
            ${{ secrets.CLIENT_SECRET }}
        serviceprincipalid:
            ${{ secrets.SERVICEPRINCIPALID }}
        tenantid:
            ${{ secrets.TENANT_ID }} 
```
