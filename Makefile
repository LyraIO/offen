help:
	@echo "    setup"
	@echo "        Build the containers and install dependencies."
	@echo "    bootstrap"
	@echo "        Create a KMS key and initialize the database."
	@echo "        IMPORTANT: this wipes any existing data in your local database."

setup:
	@docker-compose build
	@docker-compose run script npm install
	@docker-compose run vault npm install
	@docker-compose run auditorium npm install
	@docker-compose run server go mod download
	@docker-compose run kms go mod download
	@docker-compose run accounts pip install --user -r requirements.txt -r requirements-dev.txt
	@docker-compose run homepage pip install --user -r requirements.txt
	@echo "Successfully built containers and installed dependencies."
	@echo "If this is your initial setup, you can run 'make bootstrap' next"
	@echo "to create the needed local keys and seed the database."

bootstrap:
	@echo "Bootstrapping KMS service ..."
	@docker-compose run kms make bootstrap
	@echo "Bootstrapping Server service ..."
	@docker-compose run server make bootstrap
	@echo "Bootstrapping Accounts service ..."
	@docker-compose run accounts make bootstrap

.PHONY: setup bootstrap
