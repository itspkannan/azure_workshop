SUBSCRIPTION_ID := $(shell az account show --query id -o tsv)

include Makefile_role.mk
include Makefile_az.mk
include Makefile_infra.mk

.PHONY: az.install.cli

.PHONY: help
help:  ## 📖 Help message
	@echo ""
	@echo "\033[1;33mAvailable commands:\033[0m" && \
	awk -F ':.*?## ' '/^[a-zA-Z0-9_.-]+:.*## / { \
		cmds[$$1] = $$2; \
		if (length($$1) > max_len) max_len = length($$1); \
	} \
	END { \
		for (cmd in cmds) { \
			printf "  \033[36m%-" max_len "s\033[0m %s\n", cmd, cmds[cmd]; \
		} \
	}' $(MAKEFILE_LIST) | sort
	@echo ""

.PHONY: help
az.install.cli: ## Install azure cli
	@echo "[INFO] Installing Azure CLI..."
	@unameOut="$$(uname -s)"; \
	case $$unameOut in \
		Linux*) \
			echo "Detected Linux"; \
			curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash ;; \
		Darwin*) \
			echo "Detected macOS"; \
			brew update && brew install azure-cli ;; \
		*) \
			echo "Unsupported OS: $$unameOut"; exit 1 ;; \
	esac
	@echo "[INFO] Azure CLI installed"
