SHELL := /bin/bash

STOW := stow
ROOT_STOW_DIR := $(CURDIR)
CONFIG_STOW_DIR := $(CURDIR)/config
CONFIG_TARGET := $(HOME)
PACKAGES := $(sort $(notdir $(patsubst %/,%,$(wildcard $(CONFIG_STOW_DIR)/*/))))
ASSETS_TARGET := $(HOME)/Pictures
LOCAL_TARGET := $(HOME)/.local

.PHONY: help install uninstall check-all list-config config unconfig reconfig check-config assets unassets check-assets local theme-init unlocal check-local

help:
	@printf '%s\n' \
		'Usage:' \
		'  make install                      Install configs, assets, and local files' \
		'  make uninstall                    Remove all managed links' \
		'  make check-all                    Preview all managed links' \
		'' \
		'Config packages:' \
		'  make config                       Install config packages' \
		'  make unconfig                     Remove config package links' \
		'  make reconfig                     Reinstall config package links' \
		'  make check-config                 Preview config package links' \
		'  make list-config                  List config packages' \
		'  make config PACKAGES="zsh waybar"  Install selected config packages' \
		'  make assets                       Link assets into ~/Pictures' \
		'  make unassets                     Remove managed asset links' \
		'  make check-assets                 Preview asset links' \
		'  make local                        Link files into ~/.local' \
		'  make theme-init                   Install missing base theme files' \
		'  make unlocal                      Remove managed local links' \
		'  make check-local                  Preview local links'

install: config assets local theme-init

uninstall: unconfig unassets unlocal

check-all: check-config check-assets check-local

list-config:
	@printf '%s\n' $(PACKAGES)

config:
	$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --no-folding --verbose=1 $(PACKAGES)

unconfig:
	$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --delete --no-folding --verbose=1 $(PACKAGES)

reconfig:
	$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --restow --no-folding --verbose=1 $(PACKAGES)

check-config:
	$(STOW) --dir="$(CONFIG_STOW_DIR)" --target="$(CONFIG_TARGET)" --simulate --no-folding --verbose=1 $(PACKAGES)

assets:
	@mkdir -p "$(ASSETS_TARGET)"
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(ASSETS_TARGET)" --no-folding --verbose=1 assets

unassets:
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(ASSETS_TARGET)" --delete --no-folding --verbose=1 assets

check-assets:
	@mkdir -p "$(ASSETS_TARGET)"
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(ASSETS_TARGET)" --simulate --no-folding --verbose=1 assets

local:
	@mkdir -p "$(LOCAL_TARGET)"
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(LOCAL_TARGET)" --no-folding --verbose=1 local

theme-init: config
	@bash "$(CURDIR)/local/bin/matugen-theme-init"

unlocal:
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(LOCAL_TARGET)" --delete --no-folding --verbose=1 local

check-local:
	@mkdir -p "$(LOCAL_TARGET)"
	$(STOW) --dir="$(ROOT_STOW_DIR)" --target="$(LOCAL_TARGET)" --simulate --no-folding --verbose=1 local
