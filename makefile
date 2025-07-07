# 🚀 Project Bootstrap Makefile - Manual Setup Path
# This makefile provides step-by-step control for project setup
# Usage: Follow the commands in order, or use project_bootstrap.sh for auto-setup

.PHONY: init setup logs checkpoint devtools run test clean deploy-azure help validate

# 📋 Show available commands and recommended order
help:
	@echo "🚀 Project Bootstrap - Manual Setup Path"
	@echo "========================================"
	@echo ""
	@echo "📋 Recommended Setup Order:"
	@echo "  1. make validate   - Check prerequisites"
	@echo "  2. make init       - Initialize project structure"
	@echo "  3. make setup      - Setup Python environment"
	@echo "  4. make logs       - Create session logs"
	@echo "  5. make checkpoint - Mark phase completion"
	@echo "  6. make devtools   - Install development tools"
	@echo "  7. make test       - Run tests"
	@echo "  8. make run        - Run application"
	@echo ""
	@echo "🔧 Additional Commands:"
	@echo "  make clean         - Clean temporary files"
	@echo "  make deploy-azure  - Deploy to Azure"
	@echo "  make reset         - Reset runtime files"
	@echo "  make help          - Show this help"
	@echo ""
	@echo "💡 Tip: Use './project_bootstrap.sh' for complete automation"

# 🔍 Validate environment (same as validate_bootstrap.sh)
validate:
	@echo "🔍 Validating environment..."
	@which python3 > /dev/null || (echo "❌ Python 3 not found" && exit 1)
	@which pip3 > /dev/null || (echo "❌ pip3 not found" && exit 1)
	@which make > /dev/null || (echo "❌ make not found" && exit 1)
	@test -w . || (echo "❌ No write permissions" && exit 1)
	@echo "✅ Environment validation complete"

.PHONY: init logs checkpoint clean

# 💥 Initialize project structure
init:
	@mkdir -p infra src/orchestrator src/agents src/api
	@mkdir -p configs pipelines tests
	@mkdir -p docs logs .checkpoints
	@touch README.md
	@touch docs/charter.md docs/ethics.md docs/cost_control.md
	@touch docs/architecture.md docs/working_agreement.md docs/changelog.md
	@echo "logs/" >> .gitignore
	@echo ".checkpoints/" >> .gitignore
	@echo ".venv/" >> .gitignore
	@echo "__pycache__/" >> .gitignore
	@echo "*.pyc" >> .gitignore
	@echo "*.pyo" >> .gitignore
	@echo "*.pyd" >> .gitignore
	@echo ".Python" >> .gitignore
	@echo "*.egg-info/" >> .gitignore
	@echo "✅ Initialized project structure."

# 📓 Create today's log file
logs:
	@DATE=$$(date +%Y-%m-%d); \
	FILE=logs/$${DATE}_session.md; \
	echo "# Log — $${DATE}" > $$FILE; \
	echo "Created log file: $$FILE"

# 📌 Mark phase completion
checkpoint:
	@DATE=$$(date +%Y-%m-%d); \
	echo "✅ Phase checkpoint saved on $${DATE}" > .checkpoints/phase0_complete.md


# 🧹 Clean all non-Git files
clean:
	rm -rf logs/* .checkpoints/* docs/*.md
	echo "🧨 Cleaned logs, checkpoints, and docs"

# 🐍 Setup Python environment using uv (https
setup:
	@echo "🔧 Installing uv and setting up Python environment..."
	@python3 -m pip install --upgrade pip
	@python3 -m pip install uv
	@uv venv .venv
	@uv init || echo "pyproject.toml already exists"
	@uv sync
	@echo "✅ Python virtual environment set up at .venv/"

# 🧪 Install dev dependencies (optional)
devtools:
	@. .venv/bin/activate && uv pip install ruff pytest black

# 🏃 Run a script (placeholder)
run:
	@. .venv/bin/activate && python main.py

# 💻 Deploy to Azure
deploy-azure:
	@echo "🚀 Deploying Bicep template to Azure..."
	az deployment group create --resource-group $$RESOURCE_GROUP --template-file infra/main.bicep --parameters @infra/parameters.json

# ☁️ Deploy to AWS (placeholder for future Terraform support)
deploy-aws:
	@echo "🚧 AWS deployment not yet implemented. Placeholder for Terraform apply."
	@exit 1

# 🧼 Reset runtime-generated files
reset:
	@echo "🧹 Cleaning runtime-generated directories..."
	rm -rf logs/* .checkpoints/*
	@echo "✅ Cleaned logs and checkpoints."

# 📁 Clone the template into a new use case
template-clone:
	@echo "📦 Cloning blueprint into new use case: $(NAME)"
	@cp -r . ../$(NAME)
	@echo "✅ New project created at ../$(NAME)"



# 🧪 Run tests
test:
	@. .venv/bin/activate && python -m pytest tests/ -v