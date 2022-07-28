# release --- Produce all build assets necessary for a release.
.PHONY: release
release:: next-build

# run --- Run the application.
.PHONY: run
run: next-dev
