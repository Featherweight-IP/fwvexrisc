/****************************************************************************
 * wb_target_synth_stub.v
 ****************************************************************************/
`include "wishbone_macros.svh"
  
/**
 * Module: wb_target_synth_stub
 * 
 * TODO: Add module documentation
 */
module wb_target_synth_stub #(
		parameter ADDR_WIDTH=32, 
		parameter DATA_WIDTH=32
		) (
		input			clock,
		input			reset,
		`WB_TARGET_PORT(i_, ADDR_WIDTH, DATA_WIDTH)
		);
	
	reg[DATA_WIDTH-1:0]		store;
	reg						ack_r;

	always @(posedge clock or posedge reset) begin
		if (reset) begin
			store <= {DATA_WIDTH{1'b0}};
			ack_r <= 1'b0;
		end else begin
			if (i_stb && i_cyc) begin
				if (i_we) begin
					store <= ((store << 2) ^ i_adr ^ i_dat_w);
				end else begin
					store <= ((store << 2) ^ i_adr);
				end
				ack_r <= 1'b1;
			end else begin
				ack_r <= 1'b0;
			end
		end
	end 
	
	assign i_dat_r = store;

endmodule


