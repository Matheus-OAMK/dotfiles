SHELL := /bin/bash

STOW := stow
ROOT_STOW_DIR := $(CURDIR)
CONFIG_STOW_DIR := $(CURDIR)/config
CONFIG_TARGET := $(HOME)
PACKAGES := $(sort $(notdir $(patsubst %/,%,$(wildcard $(CONFIG_STOW_DIR)/*/))))
NO_FOLD_PACKAGES := $(filter dropbox,$(PACKAGES))
FOLD_PACKAGES := $(filter-out dropbox,$(PACKAGES))
ASSETS_TARGET := $(HOME)/Pictures

.PHONY: help install uninstall check-all list-config config unconfig reconfig check-config assets unassets check-assets

help:
	@printf '%s\n' \
		'Usage:' \
		'  make install                      Install configs and assets' \
		'  make uninstall                    Remove all managed links' \
		'  make check-all                    Preview all managed links' \
		'' \
		'Config packages:' \
		'  make config                       Install config packages' \
		'  make unconfig                     Remove config package links' \
		'  make reconfig                     Reinstall config package links' \
		'  make check-config                 Preview config package links' \
		'  make list-config                  List config packages' \
		'  make config PACKAGES="zsh kitty"  Install selected config packages' \
		'  make assets                       Link assets into ~/Pictures' \
		'  make unassets                     Remove managed asset links' \
		'  make check-assets                 Preview asset links'

install: config assets

uninstall: unconfig unassets

check-all: check-config check-assets

list-config:
	@printf '%s\n' $(PACKAGES)

config:
	$(if $(FOLD_PACKAGES),$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --verbose=1 $(FOLD_PACKAGES),true)
	$(if $(NO_FOLD_PACKAGES),$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --no-folding --verbose=1 $(NO_FOLD_PACKAGES),true)

unconfig:
	$(if $(NO_FOLD_PACKAGES),$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --delete --no-folding --verbose=1 $(NO_FOLD_PACKAGES),true)
	$(if $(FOLD_PACKAGES),$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --delete --verbose=1 $(FOLD_PACKAGES),true)

reconfig:
	$(if $(FOLD_PACKAGES),$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --restow --verbose=1 $(FOLD_PACKAGES),true)
	$(if $(NO_FOLD_PACKAGES),$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --restow --no-folding --verbose=1 $(NO_FOLD_PACKAGES),true)

check-config:
	$(if $(FOLD_PACKAGES),$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --simulate --verbose=1 $(FOLD_PACKAGES),true)
	$(if $(NO_FOLD_PACKAGES),$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --simulate --no-folding --verbose=1 $(NO_FOLD_PACKAGES),true)

assets:
	@mkdir -p "$(ASSETS_TARGET)"
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(ASSETS_TARGET)" --no-folding --verbose=1 assets

unassets:
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(ASSETS_TARGET)" --delete --no-folding --verbose=1 assets

check-assets:
	@mkdir -p "$(ASSETS_TARGET)"
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(ASSETS_TARGET)" --simulate --no-folding --verbose=1 assets

