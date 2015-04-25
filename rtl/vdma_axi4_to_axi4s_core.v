// ---------------------------------------------------------------------------
//  AXI4 から Read して AXI4Streamにするコア
//      受付コマンド数などは AXI interconnect などで制約できるので
//    コアはシンプルな作りとする
//
//                                      Copyright (C) 2015 by Ryuji Fuchikami
//                                      http://homepage3.nifty.com/ryuz
// ---------------------------------------------------------------------------


`timescale 1ns / 1ps
`default_nettype none


module vdma_axi4_to_axi4s_core
		#(
			parameter	AXI4_ID_WIDTH    = 6,
			parameter	AXI4_ADDR_WIDTH  = 32,
			parameter	AXI4_LEN_WIDTH   = 8,
			parameter	AXI4S_USER_WIDTH = 1,
			parameter	AXI4S_DATA_WIDTH = 24,
			parameter	STRIDE_WIDTH     = 12,
			parameter	INDEX_WIDTH      = 8,
			parameter	H_WIDTH          = 12,
			parameter	V_WIDTH          = 12,
			parameter	R_COUNT_WIDTH    = 8
		)
		(
			input	wire							aresetn,
			input	wire							aclk,
			
			// control
			input	wire							enable,
			output	wire							busy,
			
			// parameter
			input	wire	[AXI4_ADDR_WIDTH-1:0]	param_addr,
			input	wire	[STRIDE_WIDTH-1:0]		param_stride,
			input	wire	[H_WIDTH-1:0]			param_width,
			input	wire	[V_WIDTH-1:0]			param_height,
			input	wire	[AXI4_LEN_WIDTH-1:0]	param_arlen,
			
			// status
			output	wire	[INDEX_WIDTH-1:0]		status_index,
			output	wire	[AXI4_ADDR_WIDTH-1:0]	status_addr,
			output	wire	[STRIDE_WIDTH-1:0]		status_stride,
			output	wire	[H_WIDTH-1:0]			status_width,
			output	wire	[V_WIDTH-1:0]			status_height,
			output	wire	[AXI4_LEN_WIDTH-1:0]	status_arlen,
			
			// master AXI4 (read)
			output	wire	[AXI4_ID_WIDTH-1:0]		m_axi4_arid,
			output	wire	[AXI4_ADDR_WIDTH-1:0]	m_axi4_araddr,
			output	wire	[1:0]					m_axi4_arburst,
			output	wire	[3:0]					m_axi4_arcache,
			output	wire	[AXI4_LEN_WIDTH-1:0]	m_axi4_arlen,
			output	wire	[0:0]					m_axi4_arlock,
			output	wire	[2:0]					m_axi4_arprot,
			output	wire	[3:0]					m_axi4_arqos,
			output	wire	[3:0]					m_axi4_arregion,
			output	wire	[2:0]					m_axi4_arsize,
			output	wire							m_axi4_arvalid,
			input	wire							m_axi4_arready,
			input	wire	[AXI4_ID_WIDTH-1:0]		m_axi4_rid,
			input	wire	[1:0]					m_axi4_rresp,
			input	wire	[31:0]					m_axi4_rdata,
			input	wire							m_axi4_rlast,
			input	wire							m_axi4_rvalid,
			output	wire							m_axi4_rready,
			
			// master AXI4-Stream (output)
			output	wire	[AXI4S_USER_WIDTH-1:0]	m_axi4s_tuser,
			output	wire							m_axi4s_tlast,
			output	wire	[AXI4S_DATA_WIDTH-1:0]	m_axi4s_tdata,
			output	wire							m_axi4s_tvalid,
			input	wire							m_axi4s_tready,
		);
	
	// 状態管理
	reg								reg_busy;
	
	// シャドーレジスタ
	reg		[INDEX_WIDTH-1:0]		reg_index;			// この変化でホストは受付確認
	reg		[AXI4_ADDR_WIDTH-1:0]	reg_param_addr   = 0;
	reg		[STRIDE_WIDTH-1:0]		reg_param_stride = 0;
	reg		[H_WIDTH-1:0]			reg_param_width  = 0;
	reg		[V_WIDTH-1:0]			reg_param_height = 0;
	reg		[AXI4_LEN_WIDTH-1:0]	reg_param_arlen  = 0;
	
	// arチャネル制御変数
	reg								reg_arbusy;
	reg								reg_arvalid;
	reg		[AXI4_ADDR_WIDTH-1:0]	reg_addr_base;
	reg		[AXI4_ADDR_WIDTH-1:0]	reg_araddr;
	reg		[H_WIDTH-1:0]			reg_arhcnt;
	reg		[V_WIDTH-1:0]			reg_arvcnt;
	wire	[H_WIDTH-1:0]			next_arhcnt = (reg_arhcnt - reg_param_arlen - 1);
	wire	[V_WIDTH-1:0]			next_arvcnt = (reg_arvcnt - 1);
	
	// rチャネル制御変数
	reg								reg_rbusy;
	reg								reg_rfs;	// frame start
	reg								reg_rfe;	// frame end
	reg								reg_rle;	// line end
	reg		[H_WIDTH-1:0]			reg_rhcnt;
	reg		[V_WIDTH-1:0]			reg_rvcnt;
	
	wire	[H_WIDTH-1:0]			next_rhcnt = (reg_rhcnt - 1);
	wire	[V_WIDTH-1:0]			next_rvcnt = (reg_rvcnt - 1);
	
	reg		[1:0]					reg_tuser;
	reg								reg_tlast;
	
	always @(posedge aclk) begin
		if ( !aresetn ) begin
			reg_busy         <= 1'b0;
			
			reg_index        <= {INDEX_WIDTH{1'b0}};
			reg_param_addr   <= {AXI4_ADDR_WIDTH{1'bx}};
			reg_param_stride <= {STRIDE_WIDTH{1'bx}};
			reg_param_width  <= {H_WIDTH{1'bx}};
			reg_param_height <= {V_WIDTH{1'bx}};
			reg_param_arlen  <= {AXI4_LEN_WIDTH{1'bx}};
		end
		else begin
			if ( !reg_busy ) begin
				if ( enable ) begin
					reg_busy         <= 1'b1;
					reg_arbusy       <= 1'b1;
					
					reg_index        <= reg_index + 1;
					reg_param_addr   <= param_addr;
					reg_param_stride <= param_stride;
					reg_param_width  <= param_width;
					reg_param_height <= param_height;
					reg_param_arlen  <= param_arlen;
				end
			end
			
			// arチャネル制御
			if ( reg_arbusy ) begin
				if ( !reg_arvalid ) begin
					// frame start
					reg_arvalid   <= 1'b1;
					reg_addr      <= reg_param_addr;
					reg_addr_base <= reg_param_addr + (reg_param_stride << 2);
					reg_arlen     <= reg_param_arlen;
					reg_hcnt      <= reg_param_width  - 1'b1;
					reg_vcnt      <= reg_param_height - 1'b1;
					
					reg_rbusy     <= 1'b1;
					reg_rfs       <= 1'b1;
					reg_rfe       <= 1'b0;
					reg_rle       <= 1'b0;
					reg_rhcnt     <= reg_param_width  - 1'b1;
					reg_rvcnt     <= reg_param_height - 1'b1;
				end
				else begin
					if ( m_axi4_arready ) begin
						reg_addr   <= reg_addr + ((reg_arlen+1) << 2);
						reg_arhcnt <= (reg_arhcnt - reg_param_arlen - 1);
						
						if ( reg_arhcnt == 0 ) begin
							// line end
							reg_arhcnt    <= reg_param_width - 1'b1;
							reg_arvcnt    <= next_arvcnt;
							reg_addr      <= reg_addr_base;
							reg_addr_base <= reg_addr_base + (reg_param_stride << 2);
							
							if ( reg_arvcnt == 0 ) begin
								// frame end
								reg_busy    <= 1'b0;
								reg_arvalid <= 1'b0;
							end
						end
					else 
				end
			end
			
			// rチャネル制御
			if ( m_axi4_rvalid && m_axi4_rready ) begin
				reg_rfs <= 1'b0;
				reg_rfe <= (next_rhcnt == 0) && (reg_rvcnt == 0);
				reg_rle <= (next_rhcnt == 0);
				
				reg_rhcnt <= next_rhcnt;
				if ( reg_rhcnt == 0 ) begin
					reg_rvcnt <= next_rvcnt;
					if ( reg_rvcnt == 0 ) begin
						reg_rbusy <= 1'b0;
					end
				end
			end
			
			// 転送完了
			if ( !reg_arbusy && !reg_rbusy ) begin
				reg_busy <= 1'b0;
			end
		end
	end
	
	
	
	assign m_axi4_rready  = m_axi4s_tready;
	
	assign m_axi4s_tuser  = {reg_rfe, reg_rfs};	// FrameEnd はおまけ
	assign m_axi4s_tlast  = reg_rle;
	assign m_axi4s_tdata  = m_axi4_rdata;
	assign m_axi4s_tvalid = m_axi4_rvalid;
	
endmodule


`default_nettype wire


// end of file
