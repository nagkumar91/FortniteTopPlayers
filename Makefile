APP_DIR		:= distribution
BUILDS_DIR  := builds
STAGING_DIR := package
STAGING_PATH := $(STAGING_DIR)
BUILDS_PATH  := $(BUILDS_DIR)
MODULE      := lambda_package
PIP         := pip install -r

.PHONY: init invoke lint coverage clean_project build list

list:
		@echo "Options are:"
		@echo "coverage 		-> Identifies the code coverage"
		@echo "init 			-> initializes the build (installs requirements)"
		@echo "invoke 			-> makes a sample call to lambda to display the result"
		@echo "lint 			-> Performs a static code analysis on the application file."
		@echo "build			-> Builds the project."


init:
		$(PIP) requirements/development.txt

invoke:
		python app.py

lint:
		pylint --disable=W *.py

coverage:
		coverage run --source=. -m unittest discover -s .
		@echo "Coverage from unit tests: "
		coverage report -m app.py

clean_project:
		rm -rf $(STAGING_PATH)
		rm -rf $(BUILDS_PATH)

build:  clean_project
		mkdir -p $(STAGING_PATH)
		mkdir -p $(BUILDS_DIR)
		$(PIP) requirements.txt -t $(STAGING_PATH)
		cp app.py $(STAGING_PATH)
		$(eval $@FILE := deploy.zip)
		chmod -Rf 777 $(STAGING_PATH)
		cd $(STAGING_PATH); zip -r $($@FILE) ./*; mv *.zip ../$(BUILDS_DIR)
		@echo "Built $(BUILDS_DIR)/$($@FILE)"

