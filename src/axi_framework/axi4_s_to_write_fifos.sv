//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2015 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

module
  axi4_s_to_write_fifos
  #(
    A     = 32, // address bus width
    N     = 8,  // data bus width in bytes
    I     = 1,  // ID width
    W_D   = 32,
    B_D   = 2,
    AW_D  = 2,

    USE_ADVANCED_PROTOCOL = 0
  )
  (
    axi4_if axi4_s,
    axi4_if axi4_write_fifo,

    output  aw_rd_empty,
    input   aw_rd_en,
    output  w_rd_empty,
    input   w_rd_en,
    output  b_wr_full,
    input   b_wr_en,

    input   aclk,
    input   aresetn
  );

  // --------------------------------------------------------------------
  //
  localparam W_W =
    8*N + // logic [(8*N)-1:0]  wdata;
    I +   // logic [(I-1):0]    wid;
    1 +   // logic              wlast;
    N;    // logic [N-1:0]      wstrb;

  localparam B_W =
    I +   // logic [(I-1):0]    bid;
    2;    // logic [1:0]        bresp;

  localparam AX_BASIC_W =
    A +  // logic [(A-1):0]    axaddr;
    2 +  // logic [1:0]        axburst;
    I +  // logic [(I-1):0]    axid;
    8 +  // logic [7:0]        axlen;
    3;   // logic [2:0]        axsize;

  localparam AX_ADVANCED_W =
    4 +   // logic [3:0]        axcache;
    1 +   // logic              axlock;
    3 +   // logic [2:0]        axprot;
    4 +   // logic [3:0]        axqos;
    4;    // logic [3:0]        axregion;

  localparam AW_W = USE_ADVANCED_PROTOCOL ? AX_BASIC_W + AX_ADVANCED_W : AX_BASIC_W;


  // --------------------------------------------------------------------
  //
  wire [AW_W-1:0] aw_rd_data;
  wire [AW_W-1:0] aw_wr_data;

  generate
    begin: aw_data_gen
      if(USE_ADVANCED_PROTOCOL)
      begin
        assign aw_wr_data =
          {
            axi4_s.awaddr,
            axi4_s.awburst,
            axi4_s.awid,
            axi4_s.awlen,
            axi4_s.awsize,
            axi4_s.awcache,
            axi4_s.awlock,
            axi4_s.awprot,
            axi4_s.awqos,
            axi4_s.awregion
          };

        assign
          {
            axi4_write_fifo.awaddr,
            axi4_write_fifo.awburst,
            axi4_write_fifo.awid,
            axi4_write_fifo.awlen,
            axi4_write_fifo.awsize,
            axi4_write_fifo.awcache,
            axi4_write_fifo.awlock,
            axi4_write_fifo.awprot,
            axi4_write_fifo.awqos,
            axi4_write_fifo.awregion
          } = aw_rd_data;
      end
      else
      begin
        assign aw_wr_data =
          {
            axi4_s.awaddr,
            axi4_s.awburst,
            axi4_s.awid,
            axi4_s.awlen,
            axi4_s.awsize
          };

        assign
          {
            axi4_write_fifo.awaddr,
            axi4_write_fifo.awburst,
            axi4_write_fifo.awid,
            axi4_write_fifo.awlen,
            axi4_write_fifo.awsize
          } = aw_rd_data;
      end
    end
  endgenerate


  // --------------------------------------------------------------------
  //
  wire aw_wr_full;
  wire aw_wr_en = axi4_s.awready & axi4_s.awvalid;
  assign axi4_s.awready = ~aw_wr_full;

  // sync_fifo #(.W(AW_W), .D(AW_D))
  tiny_sync_fifo #(AW_W)
    aw_fifo
    (
      .wr_full(aw_wr_full),
      .wr_data(aw_wr_data),
      .wr_en(aw_wr_en),
      .rd_empty(aw_rd_empty),
      .rd_data(aw_rd_data),
      .rd_en(aw_rd_en),
      // .count(),
      .clk(aclk),
      .reset(~aresetn)
    );


  // --------------------------------------------------------------------
  //
  wire [W_W-1:0] w_rd_data;
  wire [W_W-1:0] w_wr_data;

  assign w_wr_data =
    {
      axi4_s.wdata,
      axi4_s.wid,
      axi4_s.wlast,
      axi4_s.wstrb
    };

  assign
    {
      axi4_write_fifo.wdata,
      axi4_write_fifo.wid,
      axi4_write_fifo.wlast,
      axi4_write_fifo.wstrb
    } = w_rd_data;


  // --------------------------------------------------------------------
  //
  wire w_wr_full;
  wire w_wr_en = axi4_s.wready & axi4_s.wvalid;
  assign axi4_s.wready = ~w_wr_full;

  // sync_fifo #(.W(W_W), .D(W_D))
  tiny_sync_fifo #(W_W)
    w_fifo
    (
      .wr_full(w_wr_full),
      .wr_data(w_wr_data),
      .wr_en(w_wr_en),
      .rd_empty(w_rd_empty),
      .rd_data(w_rd_data),
      .rd_en(w_rd_en),
      // .count(),
      .clk(aclk),
      .reset(~aresetn)
    );


  // --------------------------------------------------------------------
  //
  wire [B_W-1:0] b_rd_data;
  wire [B_W-1:0] b_wr_data;

  assign b_wr_data =
    {
      axi4_write_fifo.bid,
      axi4_write_fifo.bresp
    };

  assign
    {
      axi4_s.bid,
      axi4_s.bresp
    } = b_rd_data;


  // --------------------------------------------------------------------
  //
  wire b_rd_empty;
  wire b_rd_en = axi4_s.bready & axi4_s.bvalid;
  assign axi4_s.bvalid = ~b_rd_empty;

  // sync_fifo #(.W(B_W), .D(B_D))
  tiny_sync_fifo #(B_W)
    b_fifo
    (
      .wr_full(b_wr_full),
      .wr_data(b_wr_data),
      .wr_en(b_wr_en),
      .rd_empty(b_rd_empty),
      .rd_data(b_rd_data),
      .rd_en(b_rd_en),
      // .count(),
      .clk(aclk),
      .reset(~aresetn)
    );


// --------------------------------------------------------------------
//

endmodule

