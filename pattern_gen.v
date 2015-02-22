// ---------------------------------------------------------------------------
//  test pattern generator
//
//                                     Copyright (C) 2015 by Ryuji Fuchikami
//                                      http://homepage3.nifty.com/ryuz
// ---------------------------------------------------------------------------


`timescale 1ns / 1ps
`default_nettype none


module pattern_gen
		#(
			parameter	H_SYNC       = 0,
			parameter	H_VISIBLE    = 640,
			parameter	H_FRONTPORCH = 16,
			parameter	H_PULSE      = 96,
			parameter	H_BACKPORCH  = 48,
			parameter	V_SYNC       = 0,
			parameter	V_VISIBLE    = 480,
			parameter	V_FRONTPORCH = 10,
			parameter	V_PULSE      = 2,
			parameter	V_BACKPORCH  = 33
		)
		(
			input	wire			reset,
			input	wire			clk,
			
			output	wire			vsync,
			output	wire			hsync,
			output	wire			de,
			output	wire	[23:0]	data
		);
	
	localparam	H_TOTAL = H_PULSE + H_FRONTPORCH + H_VISIBLE + H_BACKPORCH;
	localparam	V_TOTAL = V_PULSE + V_FRONTPORCH + V_VISIBLE + V_BACKPORCH;
	
	reg		[11:0]	reg_h_count;
	reg		[11:0]	reg_v_count;
	
	reg				reg_vsync;
	reg				reg_hsync;
	reg				reg_de;
	reg		[23:0]	reg_data;
	
	always @(posedge clk) begin
		if ( reset ) begin
			reg_h_count <= 0;
			reg_v_count <= 0;
			
			reg_vsync   <= 0;
			reg_hsync   <= 0;
			reg_de      <= 0;
			reg_data    <= 0;
		end
		else begin
			// counter
			reg_h_count <= reg_h_count + 1;
			if ( reg_h_count == (H_TOTAL-1) ) begin
				reg_h_count <= 0;
				reg_v_count <= reg_v_count + 1;
				if ( reg_v_count == (V_TOTAL-1) ) begin
					reg_v_count <= 0;
				end
			end
			
			// output
			reg_hsync       <= (reg_h_count < H_PULSE) ? H_SYNC : ~H_SYNC;
			reg_vsync       <= (reg_v_count < V_PULSE) ? V_SYNC : ~V_SYNC;
			reg_de          <= (reg_h_count >= (H_PULSE + H_FRONTPORCH)) && (reg_h_count < (H_PULSE + H_FRONTPORCH + H_VISIBLE))
							&& (reg_v_count >= (V_PULSE + V_FRONTPORCH)) && (reg_v_count < (V_PULSE + V_FRONTPORCH + V_VISIBLE));
			reg_data[7:0]   <= reg_v_count[6] ? 8'h00 : reg_h_count[7:0];
			reg_data[15:8]  <= reg_v_count[7] ? 8'h00 : reg_h_count[7:0];
			reg_data[23:16] <= reg_v_count[8] ? 8'h00 : reg_h_count[7:0];
			
			reg_data <= {$random()};
		end
	end
	
	assign vsync = reg_vsync;
	assign hsync = reg_hsync;
	assign de    = reg_de;
	assign data  = reg_data;
	
endmodule


`default_nettype wire


// end of file
