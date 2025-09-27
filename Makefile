# Copyright (c) 2025 Sergio Gallegos - lualine-max
# MIT license, see LICENSE for more details.

# Makefile for lualine-max

.PHONY: test test-ai test-performance test-coverage install clean help

# Default target
all: test

# Run all tests
test:
	@echo "🧪 Running lualine-max tests..."
	@nvim --headless -c "lua require('tests.basic_test').run()" -c "qa!"

# Run AI tests
test-ai:
	@echo "🤖 Running AI tests..."
	@nvim --headless -c "lua require('tests.advanced_test').run()" -c "qa!"

# Run performance tests
test-performance:
	@echo "⚡ Running performance tests..."
	@nvim --headless -c "lua require('tests.performance_test').run()" -c "qa!"

# Run test coverage
test-coverage:
	@echo "📊 Running test coverage..."
	@nvim --headless -c "lua require('tests.run_tests').get_coverage()" -c "qa!"

# Install dependencies
install:
	@echo "📦 Installing dependencies..."
	@echo "No external dependencies required for lualine-max"

# Clean test artifacts
clean:
	@echo "🧹 Cleaning test artifacts..."
	@rm -rf .luacov
	@rm -f luacov.stats.out
	@rm -f luacov.report.out

# Run specific test
test-specific:
	@echo "🎯 Running specific test..."
	@nvim --headless -c "lua require('tests.run_tests').run_test('$(TEST)')" -c "qa!"

# Help
help:
	@echo "lualine-max Makefile"
	@echo "==================="
	@echo ""
	@echo "Available targets:"
	@echo "  test              - Run all tests"
	@echo "  test-ai           - Run AI integration tests"
	@echo "  test-performance  - Run performance benchmarks"
	@echo "  test-coverage      - Run test coverage analysis"
	@echo "  test-specific      - Run specific test (use TEST=test_name)"
	@echo "  install           - Install dependencies"
	@echo "  clean             - Clean test artifacts"
	@echo "  help              - Show this help"
	@echo ""
	@echo "Examples:"
	@echo "  make test"
	@echo "  make test-ai"
	@echo "  make test-performance"
	@echo "  make test-specific TEST=tests.ai.context_analyzer_spec"