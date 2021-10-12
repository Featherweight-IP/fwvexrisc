/****************************************************************************
 * fwvexrisc_rv32im_i4k_d4k_wb_top.v
 ****************************************************************************/
`include "wishbone_macros.svh"
  
/**
 * Module: fwvexrisc_rv32im_i4k_d4k_wb_top
 * 
 * TODO: Add module documentation
 */
module fwvexrisc_rv32im_i4k_d4k_wb_top(
		input 			clock,
		input 			reset,
		input 			irq,
		output[31:0]	dat_w);
	
	`WB_WIRES(c2s_, 32, 32);
	
	assign dat_w = c2s_dat_w;
	
	fwvexrisc_rv32im_i4k_d4k_wb u_core(
			.clock(			clock),
			.reset(			reset),
			`WB_CONNECT(i_, c2s_),
			.irq(			irq)
			);	

	wb_target_synth_stub #(
			.ADDR_WIDTH(32),
			.DATA_WIDTH(32)
			) u_stub (
			.clock(			clock),
			.reset(			reset),
			`WB_CONNECT(i_, c2s_)
			);


endmodule


