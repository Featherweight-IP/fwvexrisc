/****************************************************************************
 * fwvexrisc_rv32i_wb_tb.sv
 ****************************************************************************/
`ifdef NEED_TIMESCALE
`timescale 1ns/1ns
`endif

`include "wishbone_macros.svh"
`include "generic_sram_byte_en_macros.svh"

  
/**
 * Module: fwvexrisc_rv32i_wb_tb
 * 
 * TODO: Add module documentation
 */
module fwvexrisc_rv32i_wb_tb(input clock);
	
`ifdef HAVE_HDL_CLOCKGEN
	reg clock_r = 0;
	
	initial begin
		forever begin
`ifdef NEED_TIMESCALE
			#10;
`else
			#10ns;
`endif
			clock_r <= ~clock_r;
		end
	end
	assign clock = clock_r;
`endif
	
`ifdef IVERILOG
	`include "iverilog_control.svh"
`endif
	
	reg 		reset /* verilator public */ = 0;
	reg[5:0]	reset_cnt = 6'b0;
	
	always @(posedge clock) begin
		if (reset_cnt == 16) begin
			reset <= 1'b0;
		end else begin
			if (reset_cnt == 2) begin
				reset <= 1'b1;
			end
			reset_cnt <= reset_cnt + 1;
		end
	end

	`WB_WIRES(c2i_, 32, 32);

	wire irq;
	
	fwvexrisc_rv32i_wb u_dut (
		.clock    (clock   ), 
		.reset    (reset   ), 
		`WB_CONNECT(i_, c2i_),
		.irq      (irq     ));
	
	`GENERIC_SRAM_BYTE_EN_WIRES(sram_, 20, 32);
	
	fw_wishbone_sram_ctrl_single #(
		.ADR_WIDTH     (20    ), 
		.DAT_WIDTH     (32    )
		) fw_wishbone_sram_ctrl_single (
		.clock         (clock        ), 
		.reset         (reset        ), 
		`WB_CONNECT(t_, c2i_),
		`GENERIC_SRAM_BYTE_EN_CONNECT(i_, sram_)
		);
	
	generic_sram_byte_en_target_bfm #(
		.DAT_WIDTH  (32 ), 
		.ADR_WIDTH  (20 )
		) u_sram (
		.clock      (clock               ), 
		.adr        (sram_addr           ), 
		.we         (sram_write_en       ), 
		.sel        (sram_byte_en        ), 
		.dat_r      (sram_read_data      ), 
		.dat_w      (sram_write_data     ));

endmodule


