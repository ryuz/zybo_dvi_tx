// ---------------------------------------------------------------------------
//  clock & reset
//
//                                      Copyright (C) 2015 by Ryuji Fuchikami
//                                      http://homepage3.nifty.com/ryuz
// ---------------------------------------------------------------------------


`timescale 1ns / 1ps
`default_nettype none


module clkgen
		(
			input	wire	in_reset,
			input	wire	in_clk,

			output	wire	out_reset,
			output	wire	out_clk,
			output	wire	out_clk_x5
		);
	
	// clock in
	
	wire		in_clk_buf;
	IBUFG
		i_ibufg_clk
			(
				.I		(in_clk),
				.O		(in_clk_buf)
			);
	
	
	// mmcm
	wire		clkout0;
	wire		clkout1;
	wire		clkfbout;
	wire		clkfbout_buf;
	wire		locked;
	
	MMCME2_ADV
			#(
				.BANDWIDTH				("OPTIMIZED"),
				.CLKOUT4_CASCADE		("FALSE"),
				.COMPENSATION			("ZHOLD"),
				.STARTUP_WAIT			("FALSE"),
				.DIVCLK_DIVIDE			(1),
				.CLKFBOUT_MULT_F		(8.000),
				.CLKFBOUT_PHASE 		(0.000),
				.CLKFBOUT_USE_FINE_PS	("FALSE"),
				.CLKOUT0_DIVIDE_F		(40.000),
				.CLKOUT0_PHASE			(0.000),
				.CLKOUT0_DUTY_CYCLE 	(0.500),
				.CLKOUT0_USE_FINE_PS	("FALSE"),
				.CLKOUT1_DIVIDE 		(8),
				.CLKOUT1_PHASE			(0.000),
				.CLKOUT1_DUTY_CYCLE 	(0.500),
				.CLKOUT1_USE_FINE_PS	("FALSE"),
				.CLKIN1_PERIOD			(8.000),
				.REF_JITTER1			(0.010)
			)
		i_mmcm_adv
			(
				.CLKFBOUT				(clkfbout),
				.CLKFBOUTB				(),
				.CLKOUT0				(clkout0),
				.CLKOUT0B				(),
				.CLKOUT1				(clkout1),
				.CLKOUT1B				(),
				.CLKOUT2				(),
				.CLKOUT2B				(),
				.CLKOUT3				(),
				.CLKOUT3B				(),
				.CLKOUT4				(),
				.CLKOUT5				(),
				.CLKOUT6				(),
				
				.CLKFBIN				(clkfbout_buf),
				.CLKIN1 				(in_clk_buf),
				.CLKIN2 				(1'b0),
				
				.CLKINSEL				(1'b1),
				
				.DADDR					(7'h0),
				.DCLK					(1'b0),
				.DEN					(1'b0),
				.DI 					(16'h0),
				.DO 					(),
				.DRDY					(),
				.DWE					(1'b0),
				
				.PSCLK					(1'b0),
				.PSEN					(1'b0),
				.PSINCDEC				(1'b0),
				.PSDONE 				(),
				
				.LOCKED 				(locked),
				.CLKINSTOPPED			(),
				.CLKFBSTOPPED			(),
				.PWRDWN 				(1'b0),
				.RST					(in_reset)
			);
	
	BUFG
		i_bufg_clkfb
			(
				.I		(clkfbout),
				.O		(clkfbout_buf)
			);
	
	BUFG
		i_bufg_clkout1
			(
				.I		(clkout0),
				.O		(out_clk)
			);
	
	BUFG
		i_bufg_clkout2
			(
				.I		(clkout1),
				.O		(out_clk_x5)
			);
	
	
	wire			reset_n = ~in_reset & locked;
	
	reg 			reset = 1'b1;
	always @(posedge out_clk or negedge reset_n ) begin
		if ( !reset_n ) begin
			reset <= 1'b1;
		end
		else begin
			reset <= 1'b0;
		end
	end
	
	assign out_reset = reset;
	
endmodule


`default_nettype wire


// end of file
