FWVEXRISC_SYNTH_COMMONDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
FWVEXRISC_DIR := $(abspath $(FWVEXRISC_SYNTH_COMMONDIR)/../../..)
PACKAGES_DIR := $(FWVEXRISC_DIR)/packages
DV_MK := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)


ifneq (1,$(RULES))

include $(FWVEXRISC_DIR)/verilog/rtl/defs_rules.mk
include $(DV_MK)
else # Rules
include $(DV_MK)

endif
