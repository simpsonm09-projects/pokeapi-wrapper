# Cross-platform task runner for humans and agents. `just --list` shows every
# recipe. Keep each recipe a thin call to a portable tool or a script under
# scripts/. See https://github.com/simpsonm09-projects/repo-standard/blob/main/docs/task-runner.md
set windows-shell := ["powershell.exe", "-NoLogo", "-NoProfile", "-Command"]

# List the recipes.
default:
    @just --list

# Install the pinned tools.
install:
    mise install

# Install the Python dependencies for local runs and tests.
deps:
    mise run deps

# Format the Python sources with ruff.
fmt:
    mise exec -- ruff format --config .github/config/ruff.toml .

# Fail when a Python source is not ruff-formatted.
fmt-check:
    mise exec -- ruff format --config .github/config/ruff.toml --check .

# Run every linter over the tracked files.
lint:
    mise exec -- flint run --full

# Fix what the linters can fix.
lint-fix:
    mise exec -- flint run --fix

# Run the AI-slop gate.
aislop:
    npx --yes aislop@0.16.1 ci

# Run the test suite.
test:
    mise run test

# Run the suite with an lcov coverage report under coverage/.
coverage:
    mise run deps
    mise run coverage

# Regenerate docs/openapi.json from the FastAPI app.
spec:
    mise exec -- python scripts/write-openapi.py

# Fail when the generated API document differs from the code.
spec-check:
    just spec
    git diff --exit-code -- docs/openapi.json

# Serve the wrapper on http://127.0.0.1:8000 without a container.
serve:
    mise run serve

# Everything CI requires.
check: fmt-check lint test spec-check

# Historical alias for `check`, kept for the support template.
verify: check

# Install the guarded git hook.
hooks:
    git config --local core.hooksPath .githooks

# Check the .agents/skills tree and its .claude/skills links.
agent-files:
    mise exec -- node scripts/agent-files.mjs

# Prune remote-tracking refs and delete local branches merged into main.
prune:
    mise exec -- node scripts/prune.mjs
