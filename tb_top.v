

`timescale 1ns / 1ps
`default_nettype none

module tb_top();
	localparam	RATE = 1000/125.0;

	reg		clk = 1'b0;
	always #(RATE/2.0) clk = ~clk;
	
	reg		reset = 1'b1;
	always #(RATE*100) reset = 1'b0;
	
	initial begin
		$dumpfile("tb_top.vcd");
		$dumpvars(2, tb_top);
		#(RATE*800*600*2);
		$finish;
	end
	
	top
		i_top
			(
				.in_reset		(reset),
				.in_clk125		(clk),
				
				.hdmi_out_en	(),
				.hdmi_clk_p		(),
				.hdmi_clk_n		(),
				.hdmi_data_p	(),
				.hdmi_data_n	()
			);
    
	
endmodule


`default_nettype wire
