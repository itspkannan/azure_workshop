
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

.PHONY: az.activity
az.activity: ## 📜 Azure Activity Logs - Today
	@echo "[INFO] 📜 Azure Activity Logs (Today)"
	@az monitor activity-log list \
		--start-time "$$(date -I)" \
		--output table \
		--query "[].{Time:eventTimestamp, Action:operationName.value, Resource:resourceGroupName, Status:status.value}"



.PHONY: az.budget
az.budget: ## Enabled budget to prevent misuse
	@az consumption budget create --amount 0.10 --name "pk-free-tier-limit" --category cost \
		--time-grain monthly --resource-group my-rg  --notification threshold1 \
		enabled=true operator=GreaterThan threshold=90 contactEmails=$(EMAILID)

.PHONY: az.publicip.show
az.publicip.show:
	@az network public-ip show --name lb-public-ip --resource-group <your-rg> \
	--query "ipAddress" --output tsv