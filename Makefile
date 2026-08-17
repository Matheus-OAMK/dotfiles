SHELL := /bin/bash

STOW := stow
STOW_DIR := $(CURDIR)/config
TARGET := $(HOME)
PACKAGES := $(sort $(notdir $(patsubst %/,%,$(wildcard $(STOW_DIR)/*/))))
ASSETS_DIR := $(CURDIR)
ASSETS_TARGET := $(HOME)/Pictures
LOCAL_DIR := $(CURDIR)
LOCAL_TARGET := $(HOME)/.local

.PHONY: help list stow unstow restow check assets unassets check-assets local unlocal check-local

help:
	@printf '%s\n' \
		'Usage:' \
		'  make stow                         Install all packages' \
		'  make unstow                       Remove all package links' \
		'  make restow                       Reinstall all package links' \
		'  make check                        Preview and check for conflicts' \
		'  make list                         List discovered packages' \
		'  make stow PACKAGES="zsh waybar"  Operate on selected packages' \
		'  make assets                       Link assets into ~/Pictures' \
		'  make unassets                     Remove managed asset links' \
		'  make check-assets                 Preview asset links' \
		'  make local                        Link files into ~/.local' \
		'  make unlocal                      Remove managed local links' \
		'  make check-local                  Preview local links'

list:
	@printf '%s\n' $(PACKAGES)

stow:
	$(STOW) --dir="$(STOW_DIR)" --target="$(TARGET)" --verbose=1 $(PACKAGES)

unstow:
	$(STOW) --dir="$(STOW_DIR)" --target="$(TARGET)" --delete --verbose=1 $(PACKAGES)

restow:
	$(STOW) --dir="$(STOW_DIR)" --target="$(TARGET)" --restow --verbose=1 $(PACKAGES)

check:
	$(STOW) --dir="$(STOW_DIR)" --target="$(TARGET)" --simulate --verbose=1 $(PACKAGES)

assets:
	@mkdir -p "$(ASSETS_TARGET)"
	$(STOW) --dir="$(ASSETS_DIR)" --target="$(ASSETS_TARGET)" --no-folding --verbose=1 assets

unassets:
	$(STOW) --dir="$(ASSETS_DIR)" --target="$(ASSETS_TARGET)" --delete --no-folding --verbose=1 assets

check-assets:
	@mkdir -p "$(ASSETS_TARGET)"
	$(STOW) --dir="$(ASSETS_DIR)" --target="$(ASSETS_TARGET)" --simulate --no-folding --verbose=1 assets

local:
	@mkdir -p "$(LOCAL_TARGET)"
	$(STOW) --dir="$(LOCAL_DIR)" --target="$(LOCAL_TARGET)" --no-folding --verbose=1 local

unlocal:
	$(STOW) --dir="$(LOCAL_DIR)" --target="$(LOCAL_TARGET)" --delete --no-folding --verbose=1 local

check-local:
	@mkdir -p "$(LOCAL_TARGET)"
	$(STOW) --dir="$(LOCAL_DIR)" --target="$(LOCAL_TARGET)" --simulate --no-folding --verbose=1 local
