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

# TELEPRESENCE_SERVICE_PORT is the local port to use to handle an intercept.
TELEPRESENCE_SERVICE_PORT ?= $(_TELEPRESENCE_RANDOM_PORT)

# TELEPRESENCE_SERVICE_REMOTE_PORT is the remote port name or number that should
# be intercepted.
#
# It is only necessary to set this in the case that a service uses multiple
# ports. It is recommended to use a port name (not a number) if you can.
TELEPRESENCE_SERVICE_REMOTE_PORT ?=

# TELEPRESENCE_RUN_CMD is the command to use to start a local server for an
# intercept.
TELEPRESENCE_RUN_CMD ?= make run

# _TELEPRESENCE_PORT_MAPPING is the argument passed to Telepresence's --port
# option when creating an intercept.
#
# If the TELEPRESENCE_SERVICE_REMOTE_PORT variable is defined, it will be in the
# format <local port>:<remote port>, otherwise it will be just <local port>.
_TELEPRESENCE_PORT_MAPPING = $(if $(TELEPRESENCE_SERVICE_REMOTE_PORT),$(TELEPRESENCE_SERVICE_PORT):$(TELEPRESENCE_SERVICE_REMOTE_PORT),$(TELEPRESENCE_SERVICE_PORT))

################################################################################

.PHONY: intercept
intercept: pre-intercept
	CGO_ENABLED=true \
	TELEPRESENCE_SERVICE_PORT=$(TELEPRESENCE_SERVICE_PORT) \
		telepresence intercept $(TELEPRESENCE_SERVICE_NAME) --port $(_TELEPRESENCE_PORT_MAPPING) -- $(shell echo $$SHELL)

.PHONY: intercept-run
intercept-run: pre-intercept-run
	CGO_ENABLED=true \
	TELEPRESENCE_SERVICE_PORT=$(TELEPRESENCE_SERVICE_PORT) \
		telepresence intercept $(TELEPRESENCE_SERVICE_NAME) --port $(_TELEPRESENCE_PORT_MAPPING) -- $(TELEPRESENCE_RUN_CMD)

.PHONY: pre-intercept
pre-intercept::

.PHONY: pre-intercept-run
pre-intercept-run:: pre-intercept
