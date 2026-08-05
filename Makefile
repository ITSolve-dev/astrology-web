.DEFAULT_GOAL := help

.PHONY: help dev build lint format typecheck arch naming check test pr-create worktree-create worktree-cleanup squash

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

dev: ## Start development server
	bun run dev

build: ## Production build
	bun run build

lint: ## Run Biome linter with auto-fix
	bun run lint

format: ## Run Biome formatter
	bun run format

typecheck: ## Run TypeScript type check
	bun run typecheck

arch: ## Run Steiger architecture check
	bun run lint:arch

naming: ## Run check-file filename naming lint
	bun run lint:naming

check: lint format typecheck arch naming test ## Run all checks (lint + format + typecheck + arch + naming + test)

test: ## Run tests
	bun run test

pr-create: ## Create PR with auto-generated description
	@bash scripts/pr-create.sh

worktree-create: ## Create worktree (ISSUE=<n> or BRANCH=<name>)
	@bash scripts/worktree-create.sh $(if $(ISSUE),ISSUE=$(ISSUE)) $(if $(BRANCH),BRANCH=$(BRANCH))

worktree-cleanup: ## Remove worktree (NAME=<name>, or auto-detect)
	@bash scripts/worktree-cleanup.sh $(if $(NAME),NAME=$(NAME))

squash: ## Squash all commits on current branch since main (MESSAGE="...")
	@bash scripts/squash.sh "$(MESSAGE)"
