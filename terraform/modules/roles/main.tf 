resource "azurerm_role_definition" "deployer" {
  name               = "Custom Deployer"
  scope              = var.resource_group_id
  permissions {
    actions     = [
      "Microsoft.Resources/deployments/*",
      "Microsoft.Resources/subscriptions/resourceGroups/resources/write"
    ]
    not_actions = [
      "Microsoft.Resources/subscriptions/resourceGroups/resources/delete"
    ]
  }
  assignable_scopes = [var.resource_group_id]
}

resource "azurerm_role_definition" "developer" {
  name               = "Custom Developer"
  scope              = var.resource_group_id
  permissions {
    actions = [
      "Microsoft.Web/sites/*/publish/*",
      "Microsoft.Web/sites/config/*",
      "Microsoft.App/*/sourcecontrols/*"
    ]
    not_actions = [
      "Microsoft.Resources/*",
      "Microsoft.Network/*",
      "Microsoft.Compute/*"
    ]
  }
  assignable_scopes = [var.resource_group_id]
}
