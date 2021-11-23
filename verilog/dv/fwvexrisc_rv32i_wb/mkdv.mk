MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR:=$(dir $(MKDV_MK))
MKDV_TOOL ?= icarus
RISCV_CC=riscv64-zephyr-elf-gcc

include $(TEST_DIR)/../common/defs_prefix.mk
export PATH:=$(PACKAGES_DIR)/python/bin:$(PATH)
VLNV:=featherweight-ip::fwvexrisc_rv32i_wb_tb
FWVEXRISC_VL_SRCS := $(shell python3 -m mkdv files $(VLNV) -l $(FWVEXRISC_DIR) -t verilogSource)
FWVEXRISC_VL_INCS := $(shell python3 -m mkdv files $(VLNV) -l $(FWVEXRISC_DIR) -t verilogSource -i)

MKDV_VL_SRCS += $(FWVEXRISC_VL_SRCS)
MKDV_VL_INCDIRS += $(FWVEXRISC_VL_INCS)
MKDV_VL_DEFINES += FWVEXRISC_DBG_BFM_MODULE=fwvexrisc_dbg_bfm
#MKDV_VALGRIND=1
#MKDV_GDB=1


MKDV_TIMEOUT := 20ms
TOP_MODULE=fwvexrisc_rv32i_wb_tb

SW_IMAGE ?= add-01.elf

#MKDV_VL_SRCS += $(TEST_DIR)/fwvexrisc_rv32i_wb_tb.sv
VLSIM_CLKSPEC += clock=10ns
VLSIM_OPTIONS += -Wno-fatal

MKDV_COCOTB_MODULE ?= fwvexrisc_tests.riscv_compliance_tests

MKDV_RUN_DEPS += $(SW_IMAGE)
MKDV_RUN_ARGS += +sw.image=$(SW_IMAGE)

MKDV_RUN_ARGS += +ref.file=reference_output

include $(TEST_DIR)/../common/defs_rules.mk

RULES := 1

include $(TEST_DIR)/../common/defs_rules.mk

%.elf : $(PACKAGES_DIR)/riscv-compliance/riscv-test-suite/rv32i_m/I/src/%.S
	$(Q)cp $(PACKAGES_DIR)/riscv-compliance/riscv-test-suite/rv32i_m/I/references/$*.reference_output reference_output
	$(Q)$(RISCV_CC) -o $@ $^ -march=rv32i \
		-I$(TEST_DIR)/../common/include \
		-I$(PACKAGES_DIR)/riscv-compliance/riscv-test-env \
		-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
		-T$(TEST_DIR)/../common/include/linkmono.ld
