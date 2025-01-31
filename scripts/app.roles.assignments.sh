#!/bin/bash

set -xe


userAssignedIdentity="mi-lab-aws-sso"
applicationDisplayname="lab-azure-aws-sso"
role="assume-role"

# get id for  User Assigned Identity principal
principalId=$(az ad sp list --display-name $userAssignedIdentity  --query "[0].id" -o tsv)

# get id for
# resourceId=$(az ad sp list --query "[?appDisplayName=='Microsoft Graph'].id | [0]" -o tsv --all)
resourceId=$(az ad sp list --display-name $applicationDisplayname --query  "[0].id" -o tsv --all)

# retrieve id for require Microsoft Graph permissions
appRoles=( $role)
allowedMemberTypes=Application

# appRole loop
for appRole in "${appRoles[@]}"; do
  echo "assign \"$appRole\" to user assigned managed identity \"$userAssignedIdentity\""
  appRoleId=$(az ad sp list --display-name $applicationDisplayname --query "[0].appRoles[?displayName=='$appRole' && contains(allowedMemberTypes, '$allowedMemberTypes')].id" -o tsv)
  #echo "{ \"principalId\" : \"$principalId\", \"resourceId\"  : \"$resourceId\", \"appRoleId\"   : \"$appRoleId\" }" > assign."$appRole".json
  
  cat <<-EOF > $PWD/assign.$appRole.json  
{ 
  "principalId" : "$principalId", 
  "resourceId"  : "$resourceId", 
  "appRoleId"   : "$appRoleId" 
}
  
EOF

   
 
  az rest --method post \
    --uri https://graph.microsoft.com/v1.0/servicePrincipals/$principalId/appRoleAssignments \
    --body @$PWD/assign.$appRole.json \
    --headers Content-Type=application/json
done


