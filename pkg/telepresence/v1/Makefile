# TELEPRESENCE_SERVICE_NAME is the name of the service to intercept.
ifndef TELEPRESENCE_SERVICE_NAME
$(error "TELEPRESENCE_SERVICE_NAME must be defined in the project's Makefile.")
endif

# _TELEPRESENCE_RANDOM_PORT is a random port in the high range, used by default
# if TELEPRESENCE_SERVICE_PORT is not defined.
#
# It must be assigned to a variable with the := operator so that it is EAGERLY
# evaluated. Otherwise, it is evaluated each time the variable is used which
# gives a different random por teach time.
_TELEPRESENCE_RANDOM_PORT := $(shell echo $$((32768 + $$RANDOM)))

# TELEPRESENCE_SERVICE_PORT is the name or number of the port to intercept.
TELEPRESENCE_SERVICE_PORT ?= $(_TELEPRESENCE_RANDOM_PORT)

# TELEPRESENCE_RUN_CMD is the command to use to start a local server for an
# intercept.
TELEPRESENCE_RUN_CMD ?= make run

################################################################################

.PHONY: intercept
intercept: pre-intercept
	CGO_ENABLED=true \
	TELEPRESENCE_SERVICE_PORT=$(TELEPRESENCE_SERVICE_PORT) \
		telepresence intercept $(TELEPRESENCE_SERVICE_NAME) --port $(TELEPRESENCE_SERVICE_PORT) -- $(shell echo $$SHELL)

.PHONY: intercept-run
intercept-run: pre-intercept-run
	CGO_ENABLED=true \
	TELEPRESENCE_SERVICE_PORT=$(TELEPRESENCE_SERVICE_PORT) \
		telepresence intercept $(TELEPRESENCE_SERVICE_NAME) --port $(TELEPRESENCE_SERVICE_PORT) -- $(TELEPRESENCE_RUN_CMD)

.PHONY: pre-intercept
pre-intercept::

.PHONY: pre-intercept-run
pre-intercept-run:: pre-intercept
