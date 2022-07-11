# TELEPRESENCE_SERVICE_NAME is the name of the service to intercept.
ifndef TELEPRESENCE_SERVICE_NAME
$(error "TELEPRESENCE_SERVICE_NAME must be defined in the project's Makefile.")
endif

# TELEPRESENCE_SERVICE_PORT is the port to intercept.
ifndef TELEPRESENCE_SERVICE_PORT
$(error "TELEPRESENCE_SERVICE_PORT must be defined in the project's Makefile.")
endif

# TELEPRESENCE_RUN_CMD is the command to use to start a local server for an
# intercept.
TELEPRESENCE_RUN_CMD ?= make run

################################################################################

.PHONY: intercept
intercept: pre-intercept
	CGO_ENABLED=true telepresence intercept $(TELEPRESENCE_SERVICE_NAME) --port $(TELEPRESENCE_SERVICE_PORT) -- $(shell echo $$SHELL)

.PHONY: intercept-run
intercept-run: pre-intercept-run
	CGO_ENABLED=true telepresence intercept $(TELEPRESENCE_SERVICE_NAME) --port $(TELEPRESENCE_SERVICE_PORT) -- $(TELEPRESENCE_RUN_CMD)

.PHONY: pre-intercept
pre-intercept::

.PHONY: pre-intercept-run
pre-intercept-run:: pre-intercept
