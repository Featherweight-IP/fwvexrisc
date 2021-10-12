/****************************************************************************
 * fwvexrisc_rv32i_wb.v
 ****************************************************************************/

`include "wishbone_macros.svh"
  
/**
 * Module: fwvexrisc_rv32i_wb
 * 
 * TODO: Add module documentation
 */
module fwvexrisc_rv32i_wb(
		input			clock,
		input			reset,
		`WB_INITIATOR_PORT(i_, 32, 32),
		input			irq
		);
	
	wire 		iBus_cmd_valid;
	wire 		iBus_cmd_ready;
	wire[31:0]	iBus_cmd_payload_pc;
	wire		iBus_rsp_valid;
	wire		iBus_rsp_payload_error;
	wire[31:0]	iBus_rsp_payload_inst;
	
	wire		dBus_cmd_valid;
	wire		dBus_cmd_ready;
	wire		dBus_cmd_payload_wr;
	wire[31:0]	dBus_cmd_payload_address;
	wire[31:0]	dBus_cmd_payload_data;
	wire[1:0]	dBus_cmd_payload_size;
	wire		dBus_rsp_ready;
	wire		dBus_rsp_error;
	wire[31:0]	dBus_rsp_data;
	
	wire		timerInterrupt = 0;
	wire		softwareInterrupt = 0;
	
	fwvexrisc_rv32i_core u_core (
		.iBus_cmd_valid            (iBus_cmd_valid           ), 
		.iBus_cmd_ready            (iBus_cmd_ready           ), 
		.iBus_cmd_payload_pc       (iBus_cmd_payload_pc      ), 
		.iBus_rsp_valid            (iBus_rsp_valid           ), 
		.iBus_rsp_payload_error    (iBus_rsp_payload_error   ), 
		.iBus_rsp_payload_inst     (iBus_rsp_payload_inst    ), 
		.timerInterrupt            (timerInterrupt           ), 
		.externalInterrupt         (irq                      ), 
		.softwareInterrupt         (softwareInterrupt        ), 
		.dBus_cmd_valid            (dBus_cmd_valid           ), 
		.dBus_cmd_ready            (dBus_cmd_ready           ), 
		.dBus_cmd_payload_wr       (dBus_cmd_payload_wr      ), 
		.dBus_cmd_payload_address  (dBus_cmd_payload_address ), 
		.dBus_cmd_payload_data     (dBus_cmd_payload_data    ), 
		.dBus_cmd_payload_size     (dBus_cmd_payload_size    ), 
		.dBus_rsp_ready            (dBus_rsp_ready           ), 
		.dBus_rsp_error            (dBus_rsp_error           ), 
		.dBus_rsp_data             (dBus_rsp_data            ), 
		.clk                       (clock                    ), 
		.reset                     (reset                    ));
	
	reg[1:0] wb_state;
	reg dni_sel;
	
	assign dBus_rsp_error = 1'b0;
	assign iBus_rsp_payload_error = 1'b0;
	
	always @* begin
		if ((wb_state == 2'b00 && dBus_cmd_valid) || wb_state == 2'b01) begin
			dni_sel = 1;
		end else begin
			dni_sel = 0;
		end
	end
	
	reg[31:0] 	adr_r;
	reg[31:0] 	dat_w_r;
	reg[31:0] 	dat_r_r;
	reg			cyc_r;
	reg			stb_r;
	reg[3:0]	sel_r;
	reg[3:0]	tgc_r;
	reg			we_r;
	reg			iBus_cmd_ready_r;
	reg			dBus_cmd_ready_r;
	reg			iBus_rsp_valid_r;
	reg			dBus_rsp_ready_r;
	
	assign iBus_cmd_ready = iBus_cmd_ready_r;
	assign dBus_cmd_ready = dBus_cmd_ready_r;
	assign iBus_rsp_valid = iBus_rsp_valid_r;
	assign dBus_rsp_ready = dBus_rsp_ready_r;
	
	assign i_adr = adr_r;
	assign i_dat_w = dat_w_r;
	assign i_cyc = cyc_r;
	assign i_stb = stb_r;
	assign i_sel = sel_r;
	/*
	assign i_tgc = tgc_r;
	assign i_tgd_w = 1'b0;
	assign i_tga = 1'b0;
	 */
	assign i_we = we_r;

	// TODO: both interfaces are split transaction.
	assign dBus_rsp_data = dat_r_r;
	assign iBus_rsp_payload_inst = dat_r_r;
	
	reg[3:0] dwstb; // TODO:
	
	always @(posedge clock or posedge reset) begin
		if (reset) begin
			wb_state <= 2'b0;
			adr_r <= {32{1'b0}};
			dat_w_r <= {32{1'b0}};
			dat_r_r <= {32{1'b0}};
			cyc_r <= 1'b0;
			stb_r <= 1'b0;
			sel_r <= {4{1'b0}};
			tgc_r <= {4{1'b0}};
			we_r <= 1'b0;
			iBus_cmd_ready_r <= 1'b0;
			dBus_cmd_ready_r <= 1'b0;
			iBus_rsp_valid_r <= 1'b0;
			dBus_rsp_ready_r <= 1'b0;
		end else begin
			case (wb_state) // synopsys parallel_case full_case
				2'b00: begin
					iBus_cmd_ready_r <= 1'b0;
					dBus_cmd_ready_r <= 1'b0;
					iBus_rsp_valid_r <= 1'b0;
					dBus_rsp_ready_r <= 1'b0;
					if (dBus_cmd_valid) begin
						// Give priority to data
						wb_state <= 2'b01;
						adr_r <= dBus_cmd_payload_address;
						dat_w_r <= dBus_cmd_payload_data;
						cyc_r <= 1'b1;
						stb_r <= 1'b1;
						case (dBus_cmd_payload_size)
							2'b10: // 4-byte
								sel_r <= {4{1'b1}};
							2'b01: // 2-byte
								if (dBus_cmd_payload_address[1]) begin
									sel_r <= 4'b1100;
								end else begin
									sel_r <= 4'b0011;
								end
							2'b00: // 1-byte
								case (dBus_cmd_payload_address[1:0])
									2'b00: sel_r <= 4'b0001;
									2'b01: sel_r <= 4'b0010;
									2'b10: sel_r <= 4'b0100;
									2'b11: sel_r <= 4'b1000;
								endcase
						endcase
						we_r <= dBus_cmd_payload_wr;
						dBus_cmd_ready_r <= 1'b1;
//						tgc_r <= damo;
					end else if (iBus_cmd_valid) begin
						wb_state <= 2'b10;
						we_r <= 1'b0;
						adr_r <= iBus_cmd_payload_pc;
						dat_w_r <= {32{1'b0}};
						cyc_r <= 1'b1;
						stb_r <= 1'b1;
						sel_r <= {4{1'b0}};
						we_r <= 1'b0;
//						tgc_r <= {4{1'b0}};
						iBus_cmd_ready_r <= 1'b1;
					end
				end
				2'b01: begin // data
					dBus_cmd_ready_r <= 1'b0;
					if (i_cyc && i_stb && i_ack) begin
						wb_state <= 2'b00;
						dBus_rsp_ready_r <= 1'b1;
						dat_r_r <= i_dat_r;
						cyc_r <= 1'b0;
						stb_r <= 1'b0;
					end
				end
				2'b10: begin // instruction
					iBus_cmd_ready_r <= 1'b0;
					if (i_cyc && i_stb && i_ack) begin
						wb_state <= 2'b00;
						iBus_rsp_valid_r <= 1'b1;
						dat_r_r <= i_dat_r;
						cyc_r <= 1'b0;
						stb_r <= 1'b0;
					end
				end
				2'b11: begin // post-cycle turn-around
					wb_state <= 2'b00;
				end
			endcase
		end
	end	

endmodule


