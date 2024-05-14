APP_NAME := go-architecture-backend
VERSION := $(shell git describe --tags --abbrev=0)

ifeq ($(VERSION),)
	VERSION:= "v1.0.0"
endif

.PHONY: help

help: ## Help makefile.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

run-go: ## Run app
	go run cmd/api/main.go

buid-go: ## Build app
	GOOS=linux CGO_ENABLED=0  GOARCH=amd64 go build -o $(APP_NAME) cmd/api/main.go

build-nc: ## Build the image without caching
	docker build --no-cache -t $(APP_NAME) .

run: ## Run container
	docker run \
	--name $(APP_NAME) -p 8080:8080  -d $(APP_NAME)

version: ## Check version app
	@echo $(VERSION)
   
release: build-go buid-nc run ## Deploy with docker
