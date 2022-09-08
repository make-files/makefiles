# TELEPRESENCE_WORKLOAD is the name of the service to intercept.
#
# This correlates to the --workflow flag of the "telepresence intercept"
# command.
ifndef TELEPRESENCE_WORKLOAD
$(error "TELEPRESENCE_WORKLOAD must be defined in the project's Makefile.")
endif

# TELEPRESENCE_PORTS is a list of the named ports to intercept.
ifndef TELEPRESENCE_PORTS
$(error "TELEPRESENCE_PORTS must be defined in the project's Makefile.")
endif

# TELEPRESENCE_RUN_CMD is the command to use to start a local server for an
# intercept.
TELEPRESENCE_RUN_CMD ?= make run

################################################################################

.PHONY: intercept
intercept: pre-intercept
	CGO_ENABLED=true \
		$(MF_ROOT)/pkg/telepresence/v2/bin/intercept $(TELEPRESENCE_WORKLOAD) $(TELEPRESENCE_PORTS) -- $(shell echo $$SHELL)

.PHONY: intercept-run
intercept-run: pre-intercept-run
	CGO_ENABLED=true \
		$(MF_ROOT)/pkg/telepresence/v2/bin/intercept $(TELEPRESENCE_WORKLOAD) $(TELEPRESENCE_PORTS) -- $(TELEPRESENCE_RUN_CMD)

.PHONY: pre-intercept
pre-intercept::

.PHONY: pre-intercept-run
pre-intercept-run:: pre-intercept
