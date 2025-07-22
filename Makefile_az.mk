
.PHONY: az.login
az.login: ## 🔑 Login to Azure
	@az login

.PHONY: az.user.info
az.user.info: ## 👤 Show current Azure account info
	@echo "[INFO] Azure logged in user info for subscription $(SUBSCRIPTION_ID)"
	@echo ""
	@az account list --output table
	@echo ""
	@az account show --output json | jq
	@echo ""
