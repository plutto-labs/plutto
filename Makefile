PROJECT ?= plutto

SHELL := /bin/bash

run: help

BOLD ?= $(shell tput bold)
NORMAL ?= $(shell tput sgr0)

help:
	@echo "Generate a backup in the environment (staging|production) database:"
	@echo "  ${BOLD}make backup-<environment>${NORMAL}"
	@echo ""
	@echo "Copy latest database backup from the environment (staging|production) to local database:"
	@echo "  ${BOLD}make restore-from-<environment>${NORMAL}"
	@echo ""

services-port:
	@set -o pipefail; \
	docker-compose port ${SERVICE} ${PORT} 2> /dev/null | cut -d':' -f2 || echo ${PORT}

backup-staging: ROLE=staging
backup-sandbox: ROLE=sandbox
backup-production: ROLE=production
backup-%:
	@echo Capturing $(ROLE)....
	@heroku pg:backups:capture --remote $(ROLE)

restore-from-staging: ROLE=staging
restore-from-sandbox: ROLE=sandbox
restore-from-production: ROLE=production
restore-from-%:
	$(eval TEMP_FILE=$(shell mktemp))
	@echo Restoring from $(ROLE)....
	@heroku pg:backups:download --remote $(ROLE) --output $(TEMP_FILE)
	@pg_restore --verbose --clean --no-acl --no-owner -h localhost \
		-U postgres -p $(shell make services-port SERVICE=postgresql PORT=5432) -d $(PROJECT)_development $(TEMP_FILE)

swaggerize:
	@echo "Generating swagger.json...."
	@bundle exec rails rswag:specs:swaggerize RAILS_ENV=test DB_ADAPTER=nulldb
	@make replace-swagger-prefixes

replace-swagger-prefixes:
	@echo "Replacing /api/v1/ to / from paths"
	@sed -i "" "s/\/api\/v1\//\//g" ./swagger/v1/swagger.json

deploy-docs:
	@echo "Deploying swagger.json to Readme..."
	@npx rdme openapi ./swagger/v1/swagger.json --key=dL7kzpgmGrcao0dw0ebG0o3sWdjk7DO4 --id=614a1de1fe237c001ef19c49
