# APM_INSTALL_ARGS is a set of arguments passed to "apm install".
#
# It should not include --target. Which agents to deploy to is each developer's
# choice, configured once per machine using "apm config set target <target>",
# or detected by apm from files that are not committed, such as .claude/.
APM_INSTALL_ARGS ?=

################################################################################

# Keep the deployed agent configuration in sync with apm.yml whenever make is
# run without a goal, such as after a pull. It is not a prerequisite of "build"
# or "test", as nothing in the build depends on it.
.PHONY: default
default:: artifacts/apm.touch

.PHONY: precommit
precommit:: artifacts/apm.touch apm-check

.PHONY: ci
ci:: apm-check

################################################################################

# apm-check --- Fails if any agent configuration is committed outside of .apm/,
# including the files apm uses to detect which agents are in use.
.PHONY: apm-check
apm-check: $(MF_TOOL_REQ)
	$(MF_ROOT)/pkg/apm/v1/bin/check

################################################################################

# artifacts/apm.touch installs the packages declared in apm.yml, and deploys
# them to the agents configured by "apm config set target", or detected by apm.
# If there are none, nothing is deployed, and make does not try again until
# apm.yml changes, or "make clean" is run.
artifacts/apm.touch: apm.yml $(MF_TOOL_REQ)
	@mkdir -p "$(@D)"
	$(MF_ROOT)/pkg/apm/v1/bin/install "$@" $(APM_INSTALL_ARGS)
