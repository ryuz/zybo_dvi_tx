

`timescale 1ns / 1ps
`default_nettype none

module top
		(
			output	wire			hdmi_out_en,
			output	wire			hdmi_clk_p,
			output	wire			hdmi_clk_n,
			output	wire	[2:0]	hdmi_data_p,
			output	wire	[2:0]	hdmi_data_n,

			output	wire	[3:0]	led,

			inout	wire	[14:0]	DDR_addr,
			inout	wire	[2:0]	DDR_ba,
			inout	wire			DDR_cas_n,
			inout	wire			DDR_ck_n,
			inout	wire			DDR_ck_p,
			inout	wire			DDR_cke,
			inout	wire			DDR_cs_n,
			inout	wire	[3:0]	DDR_dm,
			inout	wire	[31:0]	DDR_dq,
			inout	wire	[3:0]	DDR_dqs_n,
			inout	wire	[3:0]	DDR_dqs_p,
			inout	wire			DDR_odt,
			inout	wire			DDR_ras_n,
			inout	wire			DDR_reset_n,
			inout	wire			DDR_we_n,
			inout	wire			FIXED_IO_ddr_vrn,
			inout	wire			FIXED_IO_ddr_vrp,
			inout	wire	[53:0]	FIXED_IO_mio,
			inout	wire			FIXED_IO_ps_clk,
			inout	wire			FIXED_IO_ps_porb,
			inout	wire			FIXED_IO_ps_srstb
		);


	// ----------------------------------------
	//  Processor System
	// ----------------------------------------

	wire			peri_aresetn;
	wire			peri_aclk;

	wire			mem_aresetn;
	wire			mem_aclk;

	wire			video_reset;
	wire			video_clk;
	wire			video_clk_x5;

	wire	[31:0]	axi4l_peri00_awaddr;
	wire	[2:0]	axi4l_peri00_awprot;
	wire			axi4l_peri00_awvalid;
	wire			axi4l_peri00_awready;
	wire	[3:0]	axi4l_peri00_wstrb;
	wire	[31:0]	axi4l_peri00_wdata;
	wire			axi4l_peri00_wvalid;
	wire			axi4l_peri00_wready;
	wire	[1:0]	axi4l_peri00_bresp;
	wire			axi4l_peri00_bvalid;
	wire			axi4l_peri00_bready;
	wire	[31:0]	axi4l_peri00_araddr;
	wire	[2:0]	axi4l_peri00_arprot;
	wire			axi4l_peri00_arvalid;
	wire			axi4l_peri00_arready;
	wire	[31:0]	axi4l_peri00_rdata;
	wire	[1:0]	axi4l_peri00_rresp;
	wire			axi4l_peri00_rvalid;
	wire			axi4l_peri00_rready;

	wire	[5:0]	axi4_mem00_awid;
	wire	[31:0]	axi4_mem00_awaddr;
	wire	[1:0]	axi4_mem00_awburst;
	wire	[3:0]	axi4_mem00_awcache;
	wire	[7:0]	axi4_mem00_awlen;
	wire	[0:0]	axi4_mem00_awlock;
	wire	[2:0]	axi4_mem00_awprot;
	wire	[3:0]	axi4_mem00_awqos;
	wire	[3:0]	axi4_mem00_awregion;
	wire	[2:0]	axi4_mem00_awsize;
	wire			axi4_mem00_awvalid = 0;
	wire			axi4_mem00_awready;
	wire	[3:0]	axi4_mem00_wstrb;
	wire	[31:0]	axi4_mem00_wdata;
	wire			axi4_mem00_wlast;
	wire			axi4_mem00_wvalid = 0;
	wire			axi4_mem00_wready;
	wire	[5:0]	axi4_mem00_bid;
	wire	[1:0]	axi4_mem00_bresp;
	wire			axi4_mem00_bvalid;
	wire			axi4_mem00_bready = 1;
	
	wire	[5:0]	axi4_mem00_arid;
	wire	[31:0]	axi4_mem00_araddr;
	wire	[1:0]	axi4_mem00_arburst;
	wire	[3:0]	axi4_mem00_arcache;
	wire	[7:0]	axi4_mem00_arlen;
	wire	[0:0]	axi4_mem00_arlock;
	wire	[2:0]	axi4_mem00_arprot;
	wire	[3:0]	axi4_mem00_arqos;
	wire	[3:0]	axi4_mem00_arregion;
	wire	[2:0]	axi4_mem00_arsize;
	wire			axi4_mem00_arvalid;
	wire			axi4_mem00_arready;
	wire	[5:0]	axi4_mem00_rid;
	wire	[1:0]	axi4_mem00_rresp;
	wire	[31:0]	axi4_mem00_rdata;
	wire			axi4_mem00_rlast;
	wire			axi4_mem00_rvalid;
	wire			axi4_mem00_rready;
	
	ps_core
		i_ps_core
			(
				.peri_aresetn					(peri_aresetn),
				.peri_aclk						(peri_aclk),

				.mem_aresetn					(mem_aresetn),
				.mem_aclk						(mem_aclk),

				.video_reset					(video_reset),
				.video_clk						(video_clk),
				.video_clk_x5					(video_clk_x5),

				.m_axi4l_peri00_awaddr			(axi4l_peri00_awaddr),
				.m_axi4l_peri00_awprot			(axi4l_peri00_awprot),
				.m_axi4l_peri00_awvalid			(axi4l_peri00_awvalid),
				.m_axi4l_peri00_awready			(axi4l_peri00_awready),
				.m_axi4l_peri00_wstrb			(axi4l_peri00_wstrb),
				.m_axi4l_peri00_wdata			(axi4l_peri00_wdata),
				.m_axi4l_peri00_wvalid			(axi4l_peri00_wvalid),
				.m_axi4l_peri00_wready			(axi4l_peri00_wready),
				.m_axi4l_peri00_bresp			(axi4l_peri00_bresp),
				.m_axi4l_peri00_bvalid			(axi4l_peri00_bvalid),
				.m_axi4l_peri00_bready			(axi4l_peri00_bready),
				.m_axi4l_peri00_araddr			(axi4l_peri00_araddr),
				.m_axi4l_peri00_arprot			(axi4l_peri00_arprot),
				.m_axi4l_peri00_arvalid			(axi4l_peri00_arvalid),
				.m_axi4l_peri00_arready			(axi4l_peri00_arready),
				.m_axi4l_peri00_rdata			(axi4l_peri00_rdata),
				.m_axi4l_peri00_rresp			(axi4l_peri00_rresp),
				.m_axi4l_peri00_rvalid			(axi4l_peri00_rvalid),
				.m_axi4l_peri00_rready			(axi4l_peri00_rready),

				.s_axi4_mem00_awid				(axi4_mem00_awid),
				.s_axi4_mem00_awaddr			(axi4_mem00_awaddr),
				.s_axi4_mem00_awburst			(axi4_mem00_awburst),
				.s_axi4_mem00_awcache			(axi4_mem00_awcache),
				.s_axi4_mem00_awlen				(axi4_mem00_awlen),
				.s_axi4_mem00_awlock			(axi4_mem00_awlock),
				.s_axi4_mem00_awprot			(axi4_mem00_awprot),
				.s_axi4_mem00_awqos				(axi4_mem00_awqos),
				.s_axi4_mem00_awregion			(axi4_mem00_awregion),
				.s_axi4_mem00_awsize			(axi4_mem00_awsize),
				.s_axi4_mem00_awvalid			(axi4_mem00_awvalid),
				.s_axi4_mem00_awready			(axi4_mem00_awready),
				.s_axi4_mem00_wstrb				(axi4_mem00_wstrb),
				.s_axi4_mem00_wdata				(axi4_mem00_wdata),
				.s_axi4_mem00_wlast				(axi4_mem00_wlast),
				.s_axi4_mem00_wvalid			(axi4_mem00_wvalid),
				.s_axi4_mem00_wready			(axi4_mem00_wready),
				.s_axi4_mem00_bid				(axi4_mem00_bid),
				.s_axi4_mem00_bresp				(axi4_mem00_bresp),
				.s_axi4_mem00_bvalid			(axi4_mem00_bvalid),
				.s_axi4_mem00_bready			(axi4_mem00_bready),
				.s_axi4_mem00_araddr			(axi4_mem00_araddr),
				.s_axi4_mem00_arburst			(axi4_mem00_arburst),
				.s_axi4_mem00_arcache			(axi4_mem00_arcache),
				.s_axi4_mem00_arid				(axi4_mem00_arid),
				.s_axi4_mem00_arlen				(axi4_mem00_arlen),
				.s_axi4_mem00_arlock			(axi4_mem00_arlock),
				.s_axi4_mem00_arprot			(axi4_mem00_arprot),
				.s_axi4_mem00_arqos				(axi4_mem00_arqos),
				.s_axi4_mem00_arregion			(axi4_mem00_arregion),
				.s_axi4_mem00_arsize			(axi4_mem00_arsize),
				.s_axi4_mem00_arvalid			(axi4_mem00_arvalid),
				.s_axi4_mem00_arready			(axi4_mem00_arready),
				.s_axi4_mem00_rid				(axi4_mem00_rid),
				.s_axi4_mem00_rresp				(axi4_mem00_rresp),
				.s_axi4_mem00_rdata				(axi4_mem00_rdata),
				.s_axi4_mem00_rlast				(axi4_mem00_rlast),
				.s_axi4_mem00_rvalid			(axi4_mem00_rvalid),
				.s_axi4_mem00_rready			(axi4_mem00_rready),

				.DDR_addr						(DDR_addr),
				.DDR_ba							(DDR_ba),
				.DDR_cas_n						(DDR_cas_n),
				.DDR_ck_n						(DDR_ck_n),
				.DDR_ck_p						(DDR_ck_p),
				.DDR_cke						(DDR_cke),
				.DDR_cs_n						(DDR_cs_n),
				.DDR_dm							(DDR_dm),
				.DDR_dq							(DDR_dq),
				.DDR_dqs_n						(DDR_dqs_n),
				.DDR_dqs_p						(DDR_dqs_p),
				.DDR_odt						(DDR_odt),
				.DDR_ras_n						(DDR_ras_n),
				.DDR_reset_n					(DDR_reset_n),
				.DDR_we_n						(DDR_we_n),
				.FIXED_IO_ddr_vrn				(FIXED_IO_ddr_vrn),
				.FIXED_IO_ddr_vrp				(FIXED_IO_ddr_vrp),
				.FIXED_IO_mio					(FIXED_IO_mio),
				.FIXED_IO_ps_clk				(FIXED_IO_ps_clk),
				.FIXED_IO_ps_porb				(FIXED_IO_ps_porb),
				.FIXED_IO_ps_srstb				(FIXED_IO_ps_srstb)
			);
	
	
	
	// ----------------------------------------
	//  GPO (LED)
	// ----------------------------------------
	
	gpo_axi4l
			#(
				.WIDTH							(4)
			)
		i_gpo_led
			(
				.s_axi4l_aresetn				(peri_aresetn),
				.s_axi4l_aclk					(peri_aclk),
				.s_axi4l_awaddr					(axi4l_peri00_awaddr),
				.s_axi4l_awprot					(axi4l_peri00_awprot),
				.s_axi4l_awvalid				(axi4l_peri00_awvalid),
				.s_axi4l_awready				(axi4l_peri00_awready),
				.s_axi4l_wstrb					(axi4l_peri00_wstrb),
				.s_axi4l_wdata					(axi4l_peri00_wdata),
				.s_axi4l_wvalid					(axi4l_peri00_wvalid),
				.s_axi4l_wready					(axi4l_peri00_wready),
				.s_axi4l_bresp					(axi4l_peri00_bresp),
				.s_axi4l_bvalid					(axi4l_peri00_bvalid),
				.s_axi4l_bready					(axi4l_peri00_bready),
				.s_axi4l_araddr					(axi4l_peri00_araddr),
				.s_axi4l_arprot					(axi4l_peri00_arprot),
				.s_axi4l_arvalid				(axi4l_peri00_arvalid),
				.s_axi4l_arready				(axi4l_peri00_arready),
				.s_axi4l_rdata					(axi4l_peri00_rdata),
				.s_axi4l_rresp					(axi4l_peri00_rresp),
				.s_axi4l_rvalid					(axi4l_peri00_rvalid),
				.s_axi4l_rready					(axi4l_peri00_rready),
	
				.out_data						(led)
			);
	
	
	// ----------------------------------------
	//  DMA read
	// ----------------------------------------

	wire	[0:0]			axi4s_memr_tuser;
	wire					axi4s_memr_tlast;
	wire	[23:0]			axi4s_memr_tdata;
	wire					axi4s_memr_tvalid;
	wire					axi4s_memr_tready;
	
	vdma_axi4_to_axi4s_core
			#(
				.AXI4_ID_WIDTH		(6),
				.AXI4_ADDR_WIDTH	(32),
				.AXI4_LEN_WIDTH		(8),
				.AXI4_QOS_WIDTH		(4),
				.AXI4S_USER_WIDTH	(1),
				.AXI4S_DATA_WIDTH	(24),
				.INDEX_WIDTH		(8),
				.STRIDE_WIDTH		(12),
				.H_WIDTH			(12),
				.V_WIDTH			(12)
			)
		i_vdma_axi4_to_axi4s_core
			(
				.aresetn			(mem_aresetn),
				.aclk				(mem_aclk),
				
				.enable				(1'b1),
				.busy				(),
				
				.param_addr			(0),
				.param_stride		(640),
				.param_width		(640),
				.param_height		(480),
				.param_arlen		(7),
				
				.status_index		(),
				.status_addr		(),
				.status_stride		(),
				.status_width		(),
				.status_height		(),
				.status_arlen		(),
				
				.m_axi4_arid		(axi4_mem00_arid),
				.m_axi4_araddr		(axi4_mem00_araddr),
				.m_axi4_arburst		(axi4_mem00_arburst),
				.m_axi4_arcache		(axi4_mem00_arcache),
				.m_axi4_arlen		(axi4_mem00_arlen),
				.m_axi4_arlock		(axi4_mem00_arlock),
				.m_axi4_arprot		(axi4_mem00_arprot),
				.m_axi4_arqos		(axi4_mem00_arqos),
				.m_axi4_arregion	(axi4_mem00_arregion),
				.m_axi4_arsize		(axi4_mem00_arsize),
				.m_axi4_arvalid		(axi4_mem00_arvalid),
				.m_axi4_arready		(axi4_mem00_arready),
				.m_axi4_rid			(axi4_mem00_rid),
				.m_axi4_rresp		(axi4_mem00_rresp),
				.m_axi4_rdata		(axi4_mem00_rdata),
				.m_axi4_rlast		(axi4_mem00_rlast),
				.m_axi4_rvalid		(axi4_mem00_rvalid),
				.m_axi4_rready		(axi4_mem00_rready),
				
				.m_axi4s_tuser		(axi4s_memr_tuser),
				.m_axi4s_tlast		(axi4s_memr_tlast),
				.m_axi4s_tdata		(axi4s_memr_tdata),
				.m_axi4s_tvalid		(axi4s_memr_tvalid),
				.m_axi4s_tready		(axi4s_memr_tready)
			);
	
	
	wire	[0:0]			axi4s_vout_tuser;
	wire					axi4s_vout_tlast;
	wire	[23:0]			axi4s_vout_tdata;
	wire					axi4s_vout_tvalid;
	wire					axi4s_vout_tready;
	
	jelly_fifo_async_fwtf
			#(
				.DATA_WIDTH			(2+24),
				.PTR_WIDTH			(9)
			)
		i_fifo_async_fwtf
			(
				.wr_reset			(~mem_aresetn),
				.wr_clk				(mem_aclk),
				.wr_data			({axi4s_memr_tuser[0], axi4s_memr_tlast, axi4s_memr_tdata}),
				.wr_valid			(axi4s_memr_tvalid),
				.wr_ready			(axi4s_memr_tready),
				.wr_free_num		(),
				
				.rd_reset			(video_reset),
				.rd_clk				(video_clk),
				.rd_data			({axi4s_vout_tuser[0], axi4s_vout_tlast, axi4s_vout_tdata}),
				.rd_valid			(axi4s_vout_tvalid),
				.rd_ready			(axi4s_vout_tready),
				.rd_data_num		()
			);

	wire			vout_tgen_vsync;
	wire			vout_tgen_hsync;
	wire			vout_tgen_de;
	
	pattern_gen
		i_pattern_gen
			(
				.reset				(video_reset),
				.clk				(video_clk),
				
				.vsync				(vout_tgen_vsync),
				.hsync				(vout_tgen_hsync),
				.de					(vout_tgen_de),
				.data				()
			);

	wire			vout_vsync;
	wire			vout_hsync;
	wire			vout_de;
	wire	[23:0]	vout_data;
	wire	[3:0]	vout_ctl;
	
	vout_axi4s
			#(
				.WIDTH				(24)
			)
		i_vout_axi4s
			(
				.reset				(video_reset),
				.clk				(video_clk),
				
				.s_axi4s_tuser		(axi4s_vout_tuser),
				.s_axi4s_tlast		(axi4s_vout_tlast),
				.s_axi4s_tdata		(axi4s_vout_tdata),
				.s_axi4s_tvalid		(axi4s_vout_tvalid),
				.s_axi4s_tready		(axi4s_vout_tready),
				
				.in_vsync			(vout_tgen_vsync),
				.in_hsync			(vout_tgen_hsync),
				.in_de				(vout_tgen_de),
				.in_ctl				(4'd0),
				
				.out_vsync			(vout_vsync),
				.out_hsync			(vout_hsync),
				.out_de				(vout_de),
				.out_data			(vout_data),
				.out_ctl			(vout_ctl)
			);
	
	
	// ----------------------------------------
	//  HDMI -TX
	// ----------------------------------------
	
	/*
	wire			vsync;
	wire			hsync;
	wire			de;
	wire	[23:0]	data;

	pattern_gen
//			#(
//				// SXGA@75MHz
//				.H_SYNC			(1),
//				.H_VISIBLE		(1024),
//				.H_FRONTPORCH	(24),
//				.H_PULSE		(136),
//				.H_BACKPORCH	(144),
//				.V_SYNC			(1),
//				.V_VISIBLE		(768),
//				.V_FRONTPORCH	(3),
//				.V_PULSE		(6),
//				.V_BACKPORCH	(29)
//			)
		i_pattern_gen
			(
				.reset		(video_reset),
				.clk		(video_clk),

				.vsync		(vsync),
				.hsync		(hsync),
				.de			(de),
				.data		(data)
			);
	*/
	

	assign hdmi_out_en = 1'b1;

	dvi_tx
		i_dvi_tx
			(
				.reset		(video_reset),
				.clk		(video_clk),
				.clk_x5		(video_clk_x5),

				.in_vsync	(vout_vsync),
				.in_hsync	(vout_hsync),
				.in_de		(vout_de),
				.in_data	(vout_data),
				.in_ctl		(4'd0),

				.out_clk_p	(hdmi_clk_p),
				.out_clk_n	(hdmi_clk_n),
				.out_data_p	(hdmi_data_p),
				.out_data_n	(hdmi_data_n)
			);


endmodule


`default_nettype wire


// end of file
