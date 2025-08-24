<!-- BEGIN_TF_DOCS -->
# azure-resource-group
Azure Resource Groups are logical collections of virtual machines, storage accounts, virtual networks, web apps, databases, and/or database servers. 
You can use them to group related resources for an application and divide them into groups for production and non-production, or any other organizational structure you prefer.
Each resource in Azure must belong to a resource group. A resource group is like a logical container that associates multiple resources, 
so you can manage them as a single entity—based on lifecycle and security. For example, you can create or delete resources as a group if the resources share a similar lifecycle—such as the resources for an N-tier application. 
In other words, everything that you create, manage, and deprecate together is associated within a resource group.

## azure-ad-application
To delegate identity and access management functions to Azure AD, an application must be registered with an Azure AD tenant. When you register your application with Azure AD, 
you're creating an identity configuration for your application that allows it to integrate with Azure AD. When you register an app in the Azure portal, you choose whether it's 
a single tenant, or multi-tenant, and can optionally set a redirect URI. For step-by-step instructions on registering an app, see the app registration quickstart.
When you've completed the app registration, you've a globally unique instance of the app (the application object) which lives within your home tenant or directory. 
You also have a globally unique ID for your app (the app or client ID). In the portal, you can then add secrets or certificates and scopes to make your app work, 
customize the branding of your app in the sign-in dialog, and more.
If you register an application in the portal, an application object and a service principal object are automatically created in your home tenant. 
If you register/create an application using the Microsoft Graph APIs, creating the service principal object is a separate step.

## azure-service-principal
To access resources that are secured by an Azure AD tenant, the entity that requires access must be represented by a security principal. 
This requirement is true for both users (user principal) and applications (service principal). The security principal defines the access policy and permissions 
for the user/application in the Azure AD tenant. This enables core features such as authentication of the user/application during sign-in, and authorization 
during resource access.

## azure-role-assignment
A role assignment is the process of attaching a role definition to a user, group, service principal, or managed identity at a particular scope for the purpose of 
granting access. Access is granted by creating a role assignment, and access is revoked by removing a role assignment.

## Requirements

| Name                                                                      | Version   |
|---------------------------------------------------------------------------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1  |
| <a name="requirement_azure"></a> [azure](#requirement\_azure)             | >= 3.22.0 |

## Providers

| Name                                                    | Version   |
|---------------------------------------------------------|-----------|
| <a name="provider_azure"></a> [azure](#provider\_azure) | >= 3.22.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                             | Type     |
|--------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [azurerm_resource_group.resource_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)         | resource |
| [azuread_application.ad_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application)                | resource |
| [azuread_service_principal.service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)       | resource |

## Inputs

| Name                                                                                                | Description                                                                                | Type          | Default                                                                                                                                                                                                                                                                                        | Required |
|-----------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| <a name="ic-region-id"></a> [ic-region-id](#input\_ic-region-id)                                    | The ID of the region.                                                                      | `string`      | n/a                                                                                                                                                                                                                                                                                            |   yes    |
| <a name="input_location"></a> [location](#input\_location)                                          | The location where the resources/resource groups are going to be created.                  | `string`      | n/a                                                                                                                                                                                                                                                                                            |   yes    |
| <a name="input_resource_groups_map"></a> [resource_groups_map](#input\_resource\_groups\_map)       | The resource groups that needs to be created and tags associated with it.                  | `map(string)` | {<br/>networkinfra&nbsp;=&nbsp;{<br/>&nbsp;&nbsp;tags&nbsp;=&nbsp;{<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ApplicationOwner&nbsp;=&nbsp;NetworkTeams<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;InfrastructureOwner&nbsp;=&nbsp;NetworkTeams<br/>&nbsp;&nbsp;&nbsp;}<br/>}                       |   yes    |
| <a name="input_role_assignment"></a> [repository\_role\_assignment](#input\_listener\_port) | The names of application set and role assignment groups that needs to be attached with it. | `map(string)` | {<br/>_infrastructure-live1&nbsp;=&nbsp;{<br/>&nbsp;&nbsp;&nbsp;resource-group1&nbsp;=&nbsp;[<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"Contributor",<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"Owner"<br/>&nbsp;&nbsp;&nbsp;&nbsp;]<br/>} |    no    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
