FWVEXRISC_VERILOG_RTLDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifneq (1,$(RULES))

ifeq (,$(findstring $(FWVEXRISC_VERILOG_RTLDIR),$(MKDV_INCLUDED_DEFS)))
include $(PACKAGES_DIR)/fwprotocol-defs/verilog/rtl/defs_rules.mk
MKDV_VL_SRCS += $(wildcard $(FWVEXRISC_VERILOG_RTLDIR)/*.v)
MKDV_VL_INCDIRS += $(FWVEXRISC_VERILOG_RTLDIR)

endif

else # Rules

endif
