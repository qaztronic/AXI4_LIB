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
  axi4_s_to_read_fifos
  #(
    A     = 32, // address bus width
    N     = 8,  // data bus width in bytes
    I     = 1,  // ID width
    R_D   = 32,
    AR_D  = 2,
    USE_ADVANCED_PROTOCOL = 0
  )
  (
    axi4_if axi4_s,
    axi4_if axi4_read_fifo,

    output  ar_rd_empty,
    input   ar_rd_en,
    output  r_wr_full,
    input   r_wr_en,

    input   aclk,
    input   aresetn
  );

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
            axi4_s.araddr,
            axi4_s.arburst,
            axi4_s.arid,
            axi4_s.arlen,
            axi4_s.arsize,
            axi4_s.arcache,
            axi4_s.arlock,
            axi4_s.arprot,
            axi4_s.arqos,
            axi4_s.arregion
          };

        assign
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
          } = ar_rd_data;
      end
      else
      begin
        assign ar_wr_data =
          {
            axi4_s.araddr,
            axi4_s.arburst,
            axi4_s.arid,
            axi4_s.arlen,
            axi4_s.arsize
          };

        assign
          {
            axi4_read_fifo.araddr,
            axi4_read_fifo.arburst,
            axi4_read_fifo.arid,
            axi4_read_fifo.arlen,
            axi4_read_fifo.arsize
          } = ar_rd_data;
      end
    end
  endgenerate


  // --------------------------------------------------------------------
  //
  wire ar_wr_full;
  wire ar_wr_en = axi4_s.arready & axi4_s.arvalid;
  assign axi4_s.arready = ~ar_wr_full;

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
      axi4_read_fifo.rdata,
      axi4_read_fifo.rid,
      axi4_read_fifo.rlast,
      axi4_read_fifo.rresp
    };

  assign
    {
      axi4_s.rdata,
      axi4_s.rid,
      axi4_s.rlast,
      axi4_s.rresp
    } = r_rd_data;


  // --------------------------------------------------------------------
  //
  wire r_rd_empty;
  wire r_rd_en = axi4_s.rready & axi4_s.rvalid;
  assign axi4_s.rvalid = ~r_rd_empty;

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
      // .count(),
      .clk(aclk),
      .reset(~aresetn)
    );


// --------------------------------------------------------------------
//

endmodule

