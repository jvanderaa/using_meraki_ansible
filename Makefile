
IMG_NAME=jvanderaa/working_with_meraki_ansible
IMG_VERSION=0.0.5
.DEFAULT_GOAL := test

.PHONY: build
build:
	docker build -t $(IMG_NAME):$(IMG_VERSION) . 

.PHONY: cli
cli:
	docker run -it \
		-v $(shell pwd):/local \
		$(IMG_NAME):$(IMG_VERSION) /bin/bash

.PHONY: run
run:
	docker run -itd \
		-v $(shell pwd):/local \
		-w /local \
		$(IMG_NAME):$(IMG_VERSION)

.PHONY: test
test:	lint unit

.PHONY: lint
lint:
	@echo "Starting  lint"
	docker run -v $(shell pwd):/local $(IMG_NAME):$(IMG_VERSION) sort --check requirements.txt
	docker run -v $(shell pwd):/local $(IMG_NAME):$(IMG_VERSION) black --check .
	docker run -v $(shell pwd):/local $(IMG_NAME):$(IMG_VERSION) bandit --recursive --config .bandit.yml .
	docker run -v $(shell pwd):/local $(IMG_NAME):$(IMG_VERSION) yamllint --strict .
	@echo "Completed lint"

.PHONY: unit
unit:
	@echo "Starting  unit tests"
	docker run -v $(shell pwd):/local $(IMG_NAME):$(IMG_VERSION) pytest -vv
	@echo "Completed unit tests"

.PHONY: cli


# Using to pass arguments to pylint that would fail in docker run command
.PHONY: pylint
pylint:
	find ./ -name "*.py" | xargs pylint