

`timescale 1ns / 1ps
`default_nettype none


module top
		(
			input	wire			in_reset,
			input	wire			in_clk125,
			
			output	wire			hdmi_out_en,
			output	wire			hdmi_clk_p,
			output	wire			hdmi_clk_n,
			output	wire	[2:0]	hdmi_data_p,
			output	wire	[2:0]	hdmi_data_n			
		);

	assign hdmi_out_en = 1'b1;
	
	wire		reset;
	wire		clk;
	wire		clk_x5;
	
	/*
	wire		locked;
	
	clkgen
		i_clkgen
			(
				.CLK_IN1	(in_clk125),
				
				.CLK_OUT1	(clk),
				.CLK_OUT2	(clk_x5),

				.RESET		(in_reset),
				.LOCKED		(locked)
			);
	
	reg				reset = 1'b1;
	always @(posedge clk or negedge locked ) begin
		if ( !locked ) begin
			reset <= 1'b1;
		end
		else begin
			reset <= 1'b0;
		end
	end
	*/
	
	clkgen
		i_clkgen
			(
				.in_reset	(in_reset),
				.in_clk		(in_clk125),

				.out_reset	(reset),
				.out_clk	(clk),			//  25MHz
				.out_clk_x5	(clk_x5)		// 125MHz
			);
	
	
	wire			vsync;
	wire			hsync;
	wire			de;
	wire	[23:0]	data;
	
	pattern_gen
	/*
			#(
				// SXGA@75MHz
				.H_SYNC			(1),
				.H_VISIBLE		(1024),
				.H_FRONTPORCH	(24),
				.H_PULSE		(136),
				.H_BACKPORCH	(144),
				.V_SYNC			(1),
				.V_VISIBLE		(768),
				.V_FRONTPORCH	(3),
				.V_PULSE		(6),
				.V_BACKPORCH	(29)
			)
	*/
		i_pattern_gen
			(
				.reset		(reset),
				.clk		(clk),
				
				.vsync		(vsync),
				.hsync		(hsync),
				.de			(de),
				.data		(data)
			);
	
	dvi_tx
		i_dvi_tx
			(
				.reset		(reset),
				.clk		(clk),
				.clk_x5		(clk_x5),
				
				.in_vsync	(vsync),
				.in_hsync	(hsync),
				.in_de		(de),
				.in_data	(data),
				.in_ctl		(4'd0),
				
				.out_clk_p	(hdmi_clk_p),
				.out_clk_n	(hdmi_clk_n),
				.out_data_p	(hdmi_data_p),
				.out_data_n	(hdmi_data_n)
			);
	
endmodule


`default_nettype wire


// end of file
