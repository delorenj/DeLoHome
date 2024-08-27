# Makefile for Home Assistant Docker project

# Variables
COMPOSE_FILE := docker-compose.yml
SERVICE_NAME := ha
CONTAINER_NAME := ha

# Default target
.PHONY: all
all: build up

# Build the Docker image
.PHONY: build
build:
	docker-compose -f $(COMPOSE_FILE) build $(SERVICE_NAME)

# Start the container
.PHONY: up
up:
	docker-compose -f $(COMPOSE_FILE) up -d $(SERVICE_NAME)

# Stop the container
.PHONY: down
down:
	docker-compose -f $(COMPOSE_FILE) down

# Restart the container
.PHONY: restart
restart: down up

# Show container logs
.PHONY: logs
logs:
	docker-compose -f $(COMPOSE_FILE) logs -f $(SERVICE_NAME)

# Enter the container shell
.PHONY: shell
shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash

# Check the container status
.PHONY: status
status:
	docker-compose -f $(COMPOSE_FILE) ps $(SERVICE_NAME)

# Pull the latest base image
.PHONY: pull
pull:
	docker-compose -f $(COMPOSE_FILE) pull $(SERVICE_NAME)

# Clean up unused Docker resources
.PHONY: clean
clean:
	docker system prune -f

# Update and restart the container
.PHONY: update
update: pull build restart

# Reset the onboarding flow
.PHONY: reset-onboarding
reset-onboarding:
	docker-compose -f $(COMPOSE_FILE) down
	docker-compose -f $(COMPOSE_FILE) run --rm $(SERVICE_NAME) rm -rf /config/.storage
	@echo "Onboarding flow has been reset. Start the container again with 'make up'."

# Show this help message
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all      : Build and start the container (default)"
	@echo "  build    : Build the Docker image"
	@echo "  up       : Start the container"
	@echo "  down     : Stop the container"
	@echo "  restart  : Restart the container"
	@echo "  logs     : Show container logs"
	@echo "  shell    : Enter the container shell"
	@echo "  status   : Check the container status"
	@echo "  pull     : Pull the latest base image"
	@echo "  clean    : Clean up unused Docker resources"
	@echo "  update   : Update and restart the container"
	@echo "  reset-onboarding : Reset the onboarding flow"
	@echo "  help     : Show this help message"