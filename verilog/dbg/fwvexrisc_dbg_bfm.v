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

`ifdef UNDEFINED
	wire 				rv_dbg_valid     = ivalid;
	wire[31:0] 			rv_dbg_instr     = instr;
	wire				rv_dbg_trap      = trap; 
	wire				rv_dbg_tret      = tret; 
	reg[4:0] 			rv_dbg_rd_addr   = 0; 
	reg[31:0] 			rv_dbg_rd_wdata  = 0;
	wire[31:0]			rv_dbg_pc        = pc;
	reg[31:0]			rv_dbg_mem_addr  = {32{1'b0}};
	reg[3:0]			rv_dbg_mem_wmask = {4{1'b0}};
	reg[3:0]			rv_dbg_mem_rmask = {4{1'b0}};
	reg[31:0]			rv_dbg_mem_data  = {32{1'b0}};
	
	always @(posedge clock) begin
		if (rv_dbg_valid) begin
			rv_dbg_mem_wmask <= {4{1'b0}};
			rv_dbg_mem_rmask <= {4{1'b0}};
			rv_dbg_mem_addr  <= {32{1'b0}};
			rv_dbg_mem_data <= {32{1'b0}};
			rv_dbg_rd_addr <= 0;
			rv_dbg_rd_wdata <= 0;
		end else begin
			if (mvalid) begin
				rv_dbg_mem_addr  <= maddr;
				if (mwrite) begin
					rv_dbg_mem_wmask <= mstrb;
					rv_dbg_mem_data <= mdata;
				end else begin
					rv_dbg_mem_rmask <= mstrb;
					rv_dbg_mem_data <= mdata;
				end
			end
			if (rd_write) begin
				rv_dbg_rd_addr <= rd_waddr;
				rv_dbg_rd_wdata <= rd_wdata;
			end
		end
	end	
`endif

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


