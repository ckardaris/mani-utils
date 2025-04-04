.PHONY: format
format:
	@nix-shell -p python312Packages.{isort,black,flake8} --run './scripts/code_quality.sh'

.PHONY: test
test:
	@nix-shell -p python312Packages.pytest --run "pytest --no-header -vv"

.PHONY: test-debug
test-debug:
	@nix-shell -p python312Packages.pytest --run 'pytest --no-header -vv; cd $$NIX_BUILD_TOP; bash'
