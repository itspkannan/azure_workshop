TF_DIR=./terraform
define TF_DOCKER_RUN
docker run --rm \
	--env-file .env \
	-v $(PWD)/$(TF_DIR):/workspace -w /workspace \
	hashicorp/terraform:1.8
endef

.PHONY: terraform.init
terraform.init: ## 🚀 Terraform Init
	@echo "[INFO]🚀 Terraform Init"
	$(TF_DOCKER_RUN) init

.PHONY: terraform.plan
terraform.plan: ## 🔍 Terraform Plan
	@echo "[INFO]🔍 Terraform Plan"
	$(TF_DOCKER_RUN) plan

.PHONY: terraform.apply
terraform.apply: ## ✅ Terraform Apply
	@echo "[INFO]✅ Terraform Apply"
	$(TF_DOCKER_RUN) apply -auto-approve

.PHONY: terraform.destroy
terraform.destroy: ## 🔥 Terraform Destroy
	@echo "[INFO] 🔥 Terraform Destroy"
	$(TF_DOCKER_RUN) destroy -auto-approve

.PHONY: terraform.validate
terraform.validate: ##🔎 Terraform Validate
	@echo "[INFO]🔎 Terraform Validate"
	$(TF_DOCKER_RUN) validate

.PHONY: terraform.fmt
terraform.fmt: ## 🧹 Terraform Format
	@echo "[INFO]🧹 Terraform Format"
	$(TF_DOCKER_RUN) fmt

.PHONY: terraform.show
terraform.show: ## 📜 Terraform Show
	@echo "[INFO]📜 Terraform Show"
	$(TF_DOCKER_RUN) show

.PHONY: terraform.output
terraform.output:  ## 📜 Terraform Output
	@echo "[INFO] 📦 Terraform Outputs"
	$(TF_DOCKER_RUN) output



