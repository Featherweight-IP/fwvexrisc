FWVEXRISC_VERILOG_DV_COMMONDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
FWVEXRISC_DIR := $(abspath $(FWVEXRISC_VERILOG_DV_COMMONDIR)/../../..)
PACKAGES_DIR := $(FWVEXRISC_DIR)/packages
DV_MK:=$(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)

ifneq (1,$(RULES))

MKDV_PLUGINS += pybfms cocotb
PYBFMS_MODULES += generic_sram_bfms
MKDV_PYTHONPATH += $(FWVEXRISC_VERILOG_DV_COMMONDIR)/python

include $(PACKAGES_DIR)/fw-wishbone-interconnect/verilog/rtl/defs_rules.mk
include $(PACKAGES_DIR)/fw-wishbone-sram-ctrl/verilog/rtl/defs_rules.mk
include $(FWVEXRISC_DIR)/verilog/rtl/defs_rules.mk
include $(DV_MK)
else # Rules
include $(DV_MK)
include $(FWVEXRISC_DIR)/verilog/rtl/defs_rules.mk

endif

