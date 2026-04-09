SHELL := /bin/bash
.DEFAULT_GOAL := all

FVM := fvm
FLUTTER := $(FVM) flutter
DART := $(FVM) dart

# ─── Setup ───────────────────────────────────────────────────────────────────

.PHONY: install-fvm
install-fvm: ## Install FVM via dart pub global
	dart pub global activate fvm

.PHONY: setup-fvm
setup-fvm: ## Install and pin Flutter SDK via FVM
	$(FVM) install

.PHONY: deps
deps: ## Install Flutter dependencies
	$(FLUTTER) pub get

.PHONY: setup
setup: setup-fvm deps ## Full project setup (FVM + dependencies)

# ─── Code Quality ────────────────────────────────────────────────────────────

.PHONY: analyze
analyze: ## Run dart analyze
	$(DART) analyze --fatal-infos

.PHONY: format-check
format-check: ## Check code formatting
	$(DART) format --set-exit-if-changed .

.PHONY: format
format: ## Format code
	$(DART) format .

.PHONY: lint
lint: analyze format-check ## Run all linting checks

# ─── Codegen ─────────────────────────────────────────────────────────────────

.PHONY: translations
translations: ## Generate l10n localizations from ARB files
	$(FLUTTER) gen-l10n

# ─── Build ───────────────────────────────────────────────────────────────────

.PHONY: build-apk
build-apk: ## Build Android APK (debug)
	$(FLUTTER) build apk --debug

.PHONY: build-apk-release
build-apk-release: ## Build Android APK (release)
	$(FLUTTER) build apk --release

.PHONY: build-ios
build-ios: ## Build iOS (debug, no codesign)
	$(FLUTTER) build ios --debug --no-codesign

.PHONY: build-windows
build-windows: ## Build Windows desktop
	$(FLUTTER) build windows

# ─── Run ─────────────────────────────────────────────────────────────────────

.PHONY: run
run: ## Run the app
	$(FLUTTER) run

.PHONY: run-release
run-release: ## Run the app in release mode
	$(FLUTTER) run --release

# ─── Test ────────────────────────────────────────────────────────────────────

.PHONY: test
test: ## Run all tests
	$(FLUTTER) test

# ─── Clean ───────────────────────────────────────────────────────────────────

.PHONY: clean
clean: ## Clean build artifacts
	$(FLUTTER) clean

.PHONY: clean-all
clean-all: clean ## Clean everything including deps
	rm -rf .dart_tool pubspec.lock

# ─── All ─────────────────────────────────────────────────────────────────────

.PHONY: all
all: setup translations lint test build-apk ## Full pipeline: setup, l10n, lint, test, build
	@echo "✅ All done!"

# ─── Help ────────────────────────────────────────────────────────────────────

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
