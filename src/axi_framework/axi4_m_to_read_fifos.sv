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
  axi4_m_to_read_fifos
  #(
    A=0, // address bus width
    N=0,  // data bus width in bytes
    I = 1,  // ID width
    // R_D,
    // AR_D,
    // WATERMARK = 0,
    USE_ADVANCED_PROTOCOL = 0
  )
  (
    axi4_if     axi4_m,
    axi4_if     axi4_read_fifo,

    output      ar_wr_full,
    input       ar_wr_en,
    output      r_rd_empty,
    input       r_rd_en,
    // output      r_topped_off,
    // output      r_watermark,

    input       aclk,
    input       aresetn
  );

  // // --------------------------------------------------------------------
  // //
  // localparam UB = $clog2(R_D);


  // --------------------------------------------------------------------
  //
  localparam R_W =
    8*N + //  logic [(8*N)-1:0]  rdata;
    I +   //  logic [(I-1):0]    rid;
    1 +   //  logic              rlast;
    2;    //  logic [1:0]        rresp;

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

  localparam AR_W = USE_ADVANCED_PROTOCOL ? AX_BASIC_W + AX_ADVANCED_W : AX_BASIC_W;


  // --------------------------------------------------------------------
  //
  wire [AR_W-1:0] ar_rd_data;
  wire [AR_W-1:0] ar_wr_data;

  generate
    begin: ar_data_gen
      if(USE_ADVANCED_PROTOCOL)
      begin
        assign ar_wr_data =
          {
            axi4_read_fifo.araddr,
            axi4_read_fifo.arburst,
            axi4_read_fifo.arid,
            axi4_read_fifo.arlen,
            axi4_read_fifo.arsize,
            axi4_read_fifo.arcache,
            axi4_read_fifo.arlock,
            axi4_read_fifo.arprot,
            axi4_read_fifo.arqos,
            axi4_read_fifo.arregion
          };

        assign
          {
            axi4_m.araddr,
            axi4_m.arburst,
            axi4_m.arid,
            axi4_m.arlen,
            axi4_m.arsize,
            axi4_m.arcache,
            axi4_m.arlock,
            axi4_m.arprot,
            axi4_m.arqos,
            axi4_m.arregion
          } = ar_rd_data;
      end
      else
      begin
        assign ar_wr_data =
          {
            axi4_read_fifo.araddr,
            axi4_read_fifo.arburst,
            axi4_read_fifo.arid,
            axi4_read_fifo.arlen,
            axi4_read_fifo.arsize
          };

        assign axi4_read_fifo.arcache  = 0;
        assign axi4_read_fifo.arlock   = 0;
        assign axi4_read_fifo.arprot   = 0;
        assign axi4_read_fifo.arqos    = 0;
        assign axi4_read_fifo.arregion = 0;

        assign
          {
            axi4_m.araddr,
            axi4_m.arburst,
            axi4_m.arid,
            axi4_m.arlen,
            axi4_m.arsize
          } = ar_rd_data;

        assign axi4_m.arcache  = 0;
        assign axi4_m.arlock   = 0;
        assign axi4_m.arprot   = 0;
        assign axi4_m.arqos    = 0;
        assign axi4_m.arregion = 0;

      end
    end
  endgenerate


  // --------------------------------------------------------------------
  //
  wire ar_rd_empty;
  wire ar_rd_en = axi4_m.arready & axi4_m.arvalid;
  assign axi4_m.arvalid = ~ar_rd_empty;

  // sync_fifo #(.W(AR_W), .D(AR_D))
  tiny_sync_fifo #(AR_W)
    ar_fifo
    (
      .wr_full(ar_wr_full),
      .wr_data(ar_wr_data),
      .wr_en(ar_wr_en),
      .rd_empty(ar_rd_empty),
      .rd_data(ar_rd_data),
      .rd_en(ar_rd_en),
      // .count(),
      .clk(aclk),
      .reset(~aresetn)
    );


  // --------------------------------------------------------------------
  //
  wire [R_W-1:0] r_rd_data;
  wire [R_W-1:0] r_wr_data;

  assign r_wr_data =
    {
      axi4_m.rid,
      axi4_m.rresp,
      axi4_m.rlast,
      axi4_m.rdata
    };

  assign
    {
      axi4_read_fifo.rid,
      axi4_read_fifo.rresp,
      axi4_read_fifo.rlast,
      axi4_read_fifo.rdata
    } = r_rd_data;


  // // --------------------------------------------------------------------
  // //
  // wire [UB:0] r_count;

  // generate
    // begin: r_watermark_gen
      // if(WATERMARK == 0)
      // begin
        // assign r_topped_off = 1;
        // assign r_watermark = 0;
      // end
      // else
      // begin
        // reg r_topped_off_r;
        // assign r_topped_off = r_topped_off_r;
        // assign r_watermark = r_count > WATERMARK - 1;

        // always_ff @(posedge aclk)
          // if(~aresetn | r_rd_empty)
            // r_topped_off_r <= 0;
          // else if(r_watermark)
            // r_topped_off_r <= 1;
      // end
    // end
  // endgenerate


  // --------------------------------------------------------------------
  //
  wire r_wr_full;
  wire r_wr_en = axi4_m.rready & axi4_m.rvalid;
  assign axi4_m.rready = ~r_wr_full;

  // sync_fifo #(.W(R_W), .D(R_D))
  tiny_sync_fifo #(R_W)
    r_fifo
    (
      .wr_full(r_wr_full),
      .wr_data(r_wr_data),
      .wr_en(r_wr_en),
      .rd_empty(r_rd_empty),
      .rd_data(r_rd_data),
      .rd_en(r_rd_en),
      // .count(r_count),
      .clk(aclk),
      .reset(~aresetn)
    );


// --------------------------------------------------------------------
//

endmodule

