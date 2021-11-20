
ifneq (1,$(RULES))

MKDV_PLUGINS += pybfms cocotb
PYBFMS_MODULES += generic_sram_bfms riscv_debug_bfms
MKDV_PYTHONPATH += $(FWVEXRISC_VERILOG_DV_COMMONDIR)/python

include $(DV_MK)
else # Rules
include $(DV_MK)

endif

