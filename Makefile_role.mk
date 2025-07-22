# Currently not using this 
# will use personal id 

ROLE_FILE := limited-infra-role.json
USER_NAME ?= infrauser
SUBSCRIPTION_ID := $(shell az account show --query id -o tsv)
CUSTOM_ROLE := "Limited Infra Deployer"

.PHONY: terraform.create.role
terraform.create.role: ## 🔐 Create Terraform service principal and save credentials
	@echo "[INFO] 🔐 Creating service principal - Contributor"
	@az ad sp create-for-rbac --name terraform-sp --role Contributor \
		--scopes /subscriptions/$(SUBSCRIPTION_ID) \
		--sdk-auth > .sp.json
	@echo "# Terraform SP Credentials - Appended on $$(date)" >> .env
	@cat .sp.json | jq -r '"ARM_CLIENT_ID=\(.clientId)\nARM_CLIENT_SECRET=\(.clientSecret)\nARM_SUBSCRIPTION_ID=\(.subscriptionId)\nARM_TENANT_ID=\(.tenantId)"' >> .env
	@rm -f .sp.json
	@echo "[INFO] ✅ Appended ARM credentials to .env."

.PHONY: az.create.role
az.create.role: ## 🛠️ Create custom role in Azure using template
ifeq ($(strip $(SUBSCRIPTION_ID)),)
	$(error ERROR: No active Azure subscription found. Please run `az login` and `az account set`)
endif
	@echo "[INFO] Generating role definition for subscription: $(SUBSCRIPTION_ID)"
	@sed 's|REPLACE_SUBSCRIPTION_ID|$(SUBSCRIPTION_ID)|g' limited-infra-role.json.template > $(ROLE_FILE)
	@echo "[INFO] Creating custom role..."
	@az role definition create --role-definition $(ROLE_FILE)
	@echo "[INFO] Role created successfully."

.PHONY: az.create.user
az.create.user: ## 👤 Create new Azure AD user
ifeq ($(strip $(USER_PASSWORD)),)
	$(error ERROR: Password not specified)
endif
	@echo "[INFO] Creating user: $(USER_UPN)"
	@az ad user create \
		--display-name "$(USER_NAME)" \
		--user-principal-name $(USER_UPN) \
		--password $(USER_PASSWORD) \
		--force-change-password-next-sign-in false
	@echo "[INFO] User created: $(USER_UPN)"

.PHONY: az.assign.role
az.assign.role: ## 🧾 Assign custom role to Azure user
ifeq ($(strip $(SUBSCRIPTION_ID)),)
	$(error ERROR: No active Azure subscription found. Please run `az login`)
endif
	@echo "[INFO] 🔐 Assigning role '$(CUSTOM_ROLE)' to user: $(USER_UPN)"
	@az role assignment create \
		--assignee $(USER_UPN) \
		--role "$(CUSTOM_ROLE)" \
		--scope /subscriptions/$(SUBSCRIPTION_ID)
	@echo "[INFO] Role assigned."

.PHONY: az.delete.role
az.delete.role: ## 🗑️ Delete the custom Azure role
	@echo "[INFO] 🗑️ Deleting role 'Limited Infra Deployer'..."
	@az role definition delete --name "Limited Infra Deployer"
	@echo "[INFO] ✅ Role deleted."
