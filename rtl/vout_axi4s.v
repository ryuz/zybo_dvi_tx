// ---------------------------------------------------------------------------
//  DVI transmitter
//
//                                      Copyright (C) 2015 by Ryuji Fuchikami
//                                      http://homepage3.nifty.com/ryuz
// ---------------------------------------------------------------------------


`timescale 1ns / 1ps
`default_nettype none


module vout_axi4s
		#(
			parameter	WIDTH = 24
		)
		(
			input	wire				reset,
			input	wire				clk,
			
			// slave AXI4-Stream (input)
			input	wire	[0:0]		s_axi4s_tuser,
			input	wire				s_axi4s_tlast,
			input	wire	[WIDTH-1:0]	s_axi4s_tdata,
			input	wire				s_axi4s_tvalid,
			output	wire				s_axi4s_tready,
			
			// input timing
			input	wire				in_vsync,
			input	wire				in_hsync,
			input	wire				in_de,
			input	wire	[WIDTH-1:0]	in_data,
			input	wire	[3:0]		in_ctl,
			
			// output
			output	wire				out_vsync,
			output	wire				out_hsync,
			output	wire				out_de,
			output	wire	[WIDTH-1:0]	out_data,
			output	wire	[3:0]		out_ctl
		);
	
	localparam	[1:0]	ST_WAIT_FS = 0, ST_READY = 1, ST_BUSY = 2; 
	reg		[1:0]		reg_state;
	
	reg					reg_wait_fs;
	
	reg					reg_vsync;
	reg					reg_hsync;
	reg					reg_de;
	reg		[WIDTH-1:0]	reg_data;
	reg		[3:0]		reg_ctl;
	
	
	always @(posedge clk) begin
		if ( reset ) begin
			reg_state   <= ST_WAIT_FS;
			reg_wait_fs <= 1'b0;
		end
		else begin
			// state
			case ( reg_state )
			ST_WAIT_FS:
				begin
					if ( s_axi4s_tvalid && s_axi4s_tuser ) begin
						reg_state <= ST_READY;
					end
				end
			
			ST_READY:
				begin
					if ( reg_wait_fs && in_de ) begin
						reg_state <= ST_BUSY;
					end
				end
			
			ST_BUSY:
				begin
					if ( !in_vsync ) begin
						reg_state <= ST_WAIT_FS;
					end
				end
			
			default:
				begin
					reg_state <= 2'bxx;
				end
			endcase
			
			// FS flag
			if ( !in_vsync ) begin
				reg_wait_fs <= 1'b1;
			end
			else if ( in_de ) begin
				reg_wait_fs <= 1'b0;
			end
			
			reg_vsync <= in_vsync;
			reg_hsync <= in_hsync;
			reg_de    <= in_de;
			reg_data  <= s_axi4s_tdata;
			reg_ctl   <= in_ctl;
		end
	end
	
	assign s_axi4s_tready = (reg_state == ST_BUSY && in_de) || (reg_state == ST_WAIT_FS && !s_axi4s_tuser);
	
	assign out_vsync = reg_vsync;
	assign out_hsync = reg_hsync;
	assign out_de    = reg_de;
	assign out_data  = reg_data;
	assign out_ctl   = reg_ctl;
	
endmodule


`default_nettype wire


// end of file
