# resource "azuread_application" "sp-lab-aws-sso" {
#   display_name = "sp-${local.base_name}"
# }


# resource "azuread_application_app_role" "assume-role" {
#     application_id = azuread_application.sp-lab-aws-sso.id
#     role_id = random_uuid.uuid.id
#     allowed_member_types = [ "Application" ]
#     description = "AssumeRoleWithWebIdentity"
#     display_name = "AssumeRole"
#     value = "AssumeRoleWithWebIdentity"
# }

# resource "azuread_app_role_assignment" "name" {
#     app_role_id         = azuread_application_app_role.assume-role.role_id              // ruolo
#     principal_object_id = azurerm_user_assigned_identity.mi-lab-aws-sso.principal_id       // managed identity
#     resource_object_id  = azuread_application.sp-lab-aws-sso.object_id                  // app registration
  
# }