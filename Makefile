SHELL=/bin/bash -euo pipefail

install: install-node install-python install-hooks

install-python:
	poetry install

install-node:
	npm install
	cd sandbox && npm install

install-hooks:
	cp scripts/pre-commit .git/hooks/pre-commit

lint:
	npm run lint
	find . -name '*.py' | xargs poetry run flake8
	find -name '*.sh' | grep -v node_modules | xargs shellcheck

clean:
	rm -rf build
	rm -rf dist

publish: clean
	mkdir -p build
	npm run publish 2> /dev/null

serve:
	npm run serve

check-licenses:
	npm run check-licenses
	scripts/check_python_licenses.sh

format:
	poetry run black **/*.py

sandbox: update-examples
	cd sandbox && npm run start

build-proxy:
	scripts/build_proxy.sh

release: clean publish build-proxy
	mkdir -p dist
	cp -r build/. dist

	cp ecs-proxies-deploy.yml dist/ecs-deploy-sandbox
	cp ecs-proxies-deploy.yml dist/ecs-deploy-internal-qa-sandbox

test:
	echo "TODO: add tests"
