PLUGIN_NAME := helm-env
REMOTE      := https://github.com/adamreese/$(PLUGIN_NAME)

.PHONY: install
install:
	helm plugin install $(REMOTE)

.PHONY: link
link:
	helm plugin install .
