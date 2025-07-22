# Admin User Creation



-  Create VMs, Virtual Networks, and Load Balancers
-  Assign or create custom roles
-  Not be a full admin
-  

```json
{
  "Name": "Limited Infra Deployer",
  "IsCustom": true,
  "Description": "Can create VMs, networks, LBs, and manage roles but not full admin",
  "Actions": [
    "Microsoft.Compute/*/read",
    "Microsoft.Compute/virtualMachines/*",
    "Microsoft.Network/*",
    "Microsoft.Authorization/roleAssignments/read",
    "Microsoft.Authorization/roleAssignments/write",
    "Microsoft.Authorization/roleDefinitions/read"
  ],
  "NotActions": [
    "Microsoft.Authorization/roleAssignments/delete",
    "Microsoft.Authorization/*/delete"
  ],
  "AssignableScopes": [
    "/subscriptions/<your-subscription-id>"
  ]
}

```