FWVEXRISC_VERILOG_DV_COMMONDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
FWVEXRISC_DIR := $(abspath $(FWVEXRISC_VERILOG_DV_COMMONDIR)/../../..)
PACKAGES_DIR := $(FWVEXRISC_DIR)/packages
DV_MK:=$(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)


