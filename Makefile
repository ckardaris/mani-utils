.PHONY: format
format:
	@nix-shell -p python312Packages.{isort,black,flake8} --run './scripts/python_lint_format.sh'

.PHONY: lint
lint:
	@nix-shell -p shellcheck --run 'shellcheck bin/*'

.PHONY: test
test:
	@nix-shell -p python312Packages.pytest --run "pytest --no-header -vv"

.PHONY: test-debug
test-debug:
	@nix-shell -p python312Packages.pytest --run 'pytest --no-header -vv; cd $$NIX_BUILD_TOP; bash'

.PHONY: docs
docs:
	@./scripts/make_docs.sh
