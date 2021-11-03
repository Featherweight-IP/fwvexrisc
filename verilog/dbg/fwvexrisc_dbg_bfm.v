/****************************************************************************
 * fwvexrisc_dbg_bfm.v
 ****************************************************************************/

  
/**
 * Module: fwvexrisc_dbg_bfm
 * 
 * TODO: Add module documentation
 */
module fwvexrisc_dbg_bfm(
		input			   clock,
		input			   reset,
		input              rvfi_valid,
		input     [63:0]   rvfi_order,
		input     [31:0]   rvfi_insn,
		input              rvfi_trap,
		input              rvfi_halt,
		input              rvfi_intr,
		input     [4:0]    rvfi_rs1_addr,
		input     [31:0]   rvfi_rs1_rdata,
		input     [4:0]    rvfi_rs2_addr,
		input     [31:0]   rvfi_rs2_rdata,
		input     [4:0]    rvfi_rd_addr,
		input     [31:0]   rvfi_rd_wdata,
		input     [31:0]   rvfi_pc_rdata,
		input     [31:0]   rvfi_pc_wdata,
		input     [31:0]   rvfi_mem_addr,
		input     [3:0]    rvfi_mem_rmask,
		input     [3:0]    rvfi_mem_wmask,
		input     [31:0]   rvfi_mem_rdata,
		input     [31:0]   rvfi_mem_wdata);

	riscv_debug_bfm u_dbg (
			.clock(				clock),
			.reset(				reset),
			.valid( 			rvfi_valid),
			.instr( 			rvfi_insn),
			.intr(				rvfi_intr),
			.iret(				0 /*rv_dbg_tret*/),
			.rd_addr( 			rvfi_rd_addr),
			.rd_wdata( 			rvfi_rd_wdata),
			.pc(				rvfi_pc_rdata),
			.mem_addr(			rvfi_mem_addr),
			.mem_rmask(			rvfi_mem_rmask),
			.mem_wmask(			rvfi_mem_wmask),
			.mem_data(			rvfi_mem_wdata)
		);	

endmodule


