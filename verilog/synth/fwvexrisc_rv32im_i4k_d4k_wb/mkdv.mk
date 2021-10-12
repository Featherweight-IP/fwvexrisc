MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
SYNTH_DIR:=$(dir $(MKDV_MK))
MKDV_TOOL ?= quartus

#QUARTUS_FAMILY ?= "Cyclone V"
#QUARTUS_DEVICE ?= 5CGXFC7C7F23C8

QUARTUS_FAMILY ?= "Cyclone 10 LP"
QUARTUS_DEVICE ?= 10CL025YE144A7G

TOP_MODULE = fwvexrisc_rv32im_i4k_d4k_wb_top
SDC_FILE=$(SYNTH_DIR)/$(TOP_MODULE).sdc

MKDV_VL_SRCS += $(SYNTH_DIR)/$(TOP_MODULE).v
MKDV_VL_SRCS += $(SYNTH_DIR)/wb_target_synth_stub.v

include $(SYNTH_DIR)/../common/defs_rules.mk
RULES := 1

include $(SYNTH_DIR)/../common/defs_rules.mk

