GEN_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PACKAGES_DIR := $(abspath $(GEN_DIR)/../../packages)

all : gen

CORE_SPECS += fwvexrisc_rv32i_core:fwvexrisc.FWVexRiscRv32i


.PHONY: compile
compile: 
	cd $(PACKAGES_DIR)/vexrisc ; sbt compile
	mkdir -p $(GEN_DIR)/lib
	cp $(PACKAGES_DIR)/vexrisc/target/scala-2.11/vexriscv_2.11-2.0.0.jar \
		$(GEN_DIR)/lib
	cd $(GEN_DIR) ; sbt compile

gen: 
	for s in $(CORE_SPECS); do \
		module=`echo $$s | sed -e 's/^\(.*\):.*/\1/g'`; \
		class=`echo $$s | sed -e 's/^.*:\(.*\)/\1/g'`; \
		echo "module=$$module ; class=$$class"; \
		sbt "runMain $$class"; \
		modules=`grep -w module VexRiscv.v | grep -v VexRiscv | \
			sed -e 's/module \([a-zA-Z][a-zA-Z0-9_]*\).*/\1/g'`; \
		echo "modules: $$modules"; \
		for m in $$modules; do \
			echo "Process $$m"; \
			sed -i -e "s/$${m}/$${module}_$${m}/g" VexRiscv.v; \
		done; \
		sed -i -e "s/VexRiscv/$${module}/g" VexRiscv.v; \
		cp VexRiscv.v ../rtl/$${module}.v; \
	done

clean :
	rm -rf $(GEN_DIR)/lib
	rm -rf $(GEN_DIR)/project
	rm -rf $(GEN_DIR)/target

