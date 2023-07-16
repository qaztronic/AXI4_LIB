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
  axi4_m_to_write_fifos
  #(
    A, // address bus width
    N,  // data bus width in bytes
    I = 1,  // ID width
    // W_D   = 32,
    // B_D   = 2,
    // AW_D  = 2,
    // WATERMARK = 0,
    USE_ADVANCED_PROTOCOL = 0
  )
  (
    axi4_if axi4_m,
    axi4_if axi4_write_fifo,
    output  aw_wr_full,
    input   aw_wr_en,
    output  w_wr_full,
    input   w_wr_en,
    // output  w_topped_off,
    // output  w_watermark,
    output  b_rd_empty,
    input   b_rd_en,
    input   aclk,
    input   aresetn
  );

  // // --------------------------------------------------------------------
  // //
  // localparam UB = $clog2(W_D);


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
          };

        assign
          {
            axi4_m.awaddr,
            axi4_m.awburst,
            axi4_m.awid,
            axi4_m.awlen,
            axi4_m.awsize,
            axi4_m.awcache,
            axi4_m.awlock,
            axi4_m.awprot,
            axi4_m.awqos,
            axi4_m.awregion
          } = aw_rd_data;
      end
      else
      begin
        assign aw_wr_data =
          {
            axi4_write_fifo.awaddr,
            axi4_write_fifo.awburst,
            axi4_write_fifo.awid,
            axi4_write_fifo.awlen,
            axi4_write_fifo.awsize
          };

        assign
          {
            axi4_m.awaddr,
            axi4_m.awburst,
            axi4_m.awid,
            axi4_m.awlen,
            axi4_m.awsize
          } = aw_rd_data;
      end
    end
  endgenerate


  // --------------------------------------------------------------------
  //
  wire aw_rd_empty;
  wire aw_rd_en = axi4_m.awready & axi4_m.awvalid;
  assign axi4_m.awvalid = ~aw_rd_empty;

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
      axi4_write_fifo.wdata,
      axi4_write_fifo.wid,
      axi4_write_fifo.wlast,
      axi4_write_fifo.wstrb
    };

  assign
    {
      axi4_m.wdata,
      axi4_m.wid,
      axi4_m.wlast,
      axi4_m.wstrb
    } = w_rd_data;


  // --------------------------------------------------------------------
  //
  // wire [UB:0] w_count;
  wire w_rd_empty;
  wire w_rd_en = axi4_m.wready & axi4_m.wvalid;
  assign axi4_m.wvalid = ~w_rd_empty;

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
      // .count(w_count),
      .clk(aclk),
      .reset(~aresetn)
    );


  // // --------------------------------------------------------------------
  // //
  // generate
    // begin: w_watermark_gen
      // if(WATERMARK == 0)
      // begin
        // assign w_topped_off = 1;
        // assign w_watermark = 0;
      // end
      // else
      // begin
        // reg w_topped_off_r;
        // assign w_topped_off = w_topped_off_r;
        // assign w_watermark = w_count > WATERMARK - 1;

        // always_ff @(posedge aclk)
          // if(~aresetn | w_rd_empty)
            // w_topped_off_r <= 0;
          // else if(w_watermark)
            // w_topped_off_r <= 1;
      // end
    // end
  // endgenerate


  // --------------------------------------------------------------------
  //
  wire [B_W-1:0] b_rd_data;
  wire [B_W-1:0] b_wr_data;

  assign b_wr_data =
    {
      axi4_m.bid,
      axi4_m.bresp
    };

  assign
    {
      axi4_write_fifo.bid,
      axi4_write_fifo.bresp
    } = b_rd_data;


  // --------------------------------------------------------------------
  //
  wire b_wr_full;
  wire b_wr_en = axi4_m.bready & axi4_m.bvalid;
  assign axi4_m.bready = ~b_wr_full;

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

