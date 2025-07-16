# Makefile for building and installing markdown_normalization Python wheel

PACKAGE_NAME := markdown_normalization
PYTHON := $(shell which python)

.PHONY: all check-deps install-deps build install clean

all: check-deps install-deps build test install clean

check-deps:
	@command -v rustc >/dev/null 2>&1 || { echo >&2 "❌ rustc not found. Please install Rust: https://rustup.rs"; exit 1; }
	@command -v cargo >/dev/null 2>&1 || { echo >&2 "❌ cargo not found. Please install Rust: https://rustup.rs"; exit 1; }
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo >&2 "❌ $(PYTHON) not found."; exit 1; }

install-deps:
	@$(PYTHON) -m pip show maturin >/dev/null 2>&1 || { \
		echo "📦 Installing maturin..."; \
		python3 -m pip install --upgrade maturin; \
	}

build:
	@echo "🔨 Building wheel with maturin..."
	@maturin build --release --strip

clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf build dist target *.egg-info

test:
	@echo "🧪 Running tests..."
	@$(PYTHON) -m pip install pytest
	@$(PYTHON) -m pytest -v -s


install:
	@echo "📦 Installing wheel locally..."
	@pip install --force-reinstall --no-cache-dir target/wheels/$(PACKAGE_NAME)-*.whl
