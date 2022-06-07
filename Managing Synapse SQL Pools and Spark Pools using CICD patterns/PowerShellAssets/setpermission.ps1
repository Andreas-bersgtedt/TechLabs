# Params here
param ([string]$WorkspaceName,[string]$RoleName,[string]$SPName)
#force install of Az.Synapse
Install-Module -Name Az.Synapse -Scope CurrentUser -Repository PSGallery -Force
#Apply Roles
try { New-AzSynapseRoleAssignment -WorkspaceName $WorkspaceName -RoleDefinitionName $RoleName -SignInName $SPName }
catch {   
Write-Host "An error occurred:"
Write-Host $Error
}