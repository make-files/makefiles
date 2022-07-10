# TELEPRESENCE_SERVICE_NAME is the name of the service to intercept.
ifndef TELEPRESENCE_SERVICE_NAME
$(error "TELEPRESENCE_SERVICE_NAME must be defined in the project's Makefile.")
endif

# TELEPRESENCE_SERVICE_PORT is the port to intercept.
ifndef TELEPRESENCE_SERVICE_PORT
$(error "TELEPRESENCE_SERVICE_PORT must be defined in the project's Makefile.")
endif

# TELEPRESENCE_INTERCEPT_REQ is a space separated list of prerequisites needed
# to perform an intercept.
TELEPRESENCE_INTERCEPT_REQ +=

# TELEPRESENCE_RUN_CMD is the command to use to start a local server for an
# intercept.
TELEPRESENCE_RUN_CMD ?= make run

# TELEPRESENCE_RUN_REQ is a space separated list of prerequisites needed to run
# the command specified by TELEPRESENCE_RUN_CMD.
TELEPRESENCE_RUN_REQ +=

################################################################################

.PHONY: intercept
intercept: $(TELEPRESENCE_INTERCEPT_REQ)
	CGO_ENABLED=true telepresence intercept $(TELEPRESENCE_SERVICE_NAME) --port $(TELEPRESENCE_SERVICE_PORT) -- $(shell echo $$SHELL)

.PHONY: intercept-run
intercept-run: $(TELEPRESENCE_INTERCEPT_REQ) $(TELEPRESENCE_RUN_REQ)
	CGO_ENABLED=true telepresence intercept $(TELEPRESENCE_SERVICE_NAME) --port $(TELEPRESENCE_SERVICE_PORT) -- $(TELEPRESENCE_RUN_CMD)
