

`timescale 1n/1p
`default_nettype none


module gpo_axi4l
		#(
			parameter	WIDTH      = 32,
			parameter	INIT_VALUE = 0
		)
		(
			input	wire					s_axi4l_aresetn,
			input	wire					s_axi4l_aclk,
			input	wire	[31:0]			s_axi4l_awaddr,
			input	wire	[2:0]			s_axi4l_awprot,
			input	wire					s_axi4l_awvalid,
			output	wire					s_axi4l_awready,
			input	wire	[3:0]			s_axi4l_wstrb,
			input	wire	[31:0]			s_axi4l_wdata,
			input	wire					s_axi4l_wvalid,
			input	wire					s_axi4l_wready,
			output	wire	[1:0]			s_axi4l_bresp,
			output	wire					s_axi4l_bvalid,
			input	wire					s_axi4l_bready,
			input	wire	[31:0]			s_axi4l_araddr,
			input	wire	[2:0]			s_axi4l_arprot,
			input	wire					s_axi4l_arvalid,
			output	wire					s_axi4l_arready,
			output	wire	[31:0]			s_axi4l_rdata,
			output	wire	[1:0]			s_axi4l_rresp,
			output	wire					s_axi4l_rvalid,
			input	wire					s_axi4l_rready,

			output	wire	[WIDTH-1:0]		out_data
		);

	reg		[WIDTH-1:0]		reg_data;

	reg						reg_bvalid;
	reg						reg_rvalid;

	always @(posedge s_axi4l_aclk) begin
		if ( !s_axi4l_aresetn ) begin
			reg_data   <= INIT_VALUE;

			reg_bvalid <= 1'b0;
			reg_rvalid <= 1'b0;;
		end
		else begin
			// write
			if ( s_axi4l_wvalid ) begin
				reg_data <= s_axi4l_wdata[WIDTH-1:0];
			end

			if ( s_axi4l_bready ) begin
				reg_bvalid <= 1'b0;
			end
			if ( s_axi4l_awvalid && s_axi4l_wvalid ) begin
				reg_bvalid <= 1'b1;
			end

			// read
			if ( s_axi4l_rready ) begin
				reg_rvalid <= 1'b0;
			end
			if ( s_axi4l_arvalid ) begin
				reg_rvalid <= 1'b1;
			end
		end
	end

	assign s_axi4l_awready = (s_axi4l_wvalid  && (s_axi4l_bready || !s_axi4l_bvalid));
	assign s_axi4l_wready  = (s_axi4l_awvalid && (s_axi4l_bready || !s_axi4l_bvalid));
	assign s_axi4l_bresp   = 0;
	assign s_axi4l_bvalid  = reg_bvalid;

	assign s_axi4l_arready = (s_axi4l_rready || !s_axi4l_rvalid);
	assign s_axi4l_rdata   = reg_data;
	assign s_axi4l_rresp   = 0;
	assign s_axi4l_rvalid  = reg_rvalid;

	assign out_data = reg_data;

endmodule


`default_nettype wire


// end of file
