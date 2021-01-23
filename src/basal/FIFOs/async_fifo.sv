//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2016 Authors and OPENCORES.ORG                 ////
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


// --------------------------------------------------------------------
//
module
  cummings_sync_r2w
  #(
    parameter ADDRSIZE = 4
  )
  (
    output reg [ADDRSIZE:0] wq2_rptr,
    input [ADDRSIZE:0]      rptr,
    input                   wclk,
    input                   wrst_n
  );

  reg [ADDRSIZE:0] wq1_rptr;

  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      {wq2_rptr,wq1_rptr} <= 0;
    else
      {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};

endmodule


// --------------------------------------------------------------------
//
module
  cummings_sync_w2r
  #(
    parameter ADDRSIZE = 4
  )
  (
    output reg  [ADDRSIZE:0]  rq2_wptr,
    input       [ADDRSIZE:0]  wptr,
    input                     rclk,
    input                     rrst_n
  );

  reg [ADDRSIZE:0] rq1_wptr;

  always @(posedge rclk or negedge rrst_n)
    if(!rrst_n)
      {rq2_wptr,rq1_wptr} <= 0;
    else
      {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};

endmodule


// --------------------------------------------------------------------
//
module
  cummings_fifomem
  #(
    parameter DATASIZE = 8,   // Memory data word width
    parameter ADDRSIZE = 4    // Number of mem address bits
  )
  (
    output [DATASIZE-1:0] rdata,
    input [DATASIZE-1:0]  wdata,
    input [ADDRSIZE-1:0]  waddr,
    input [ADDRSIZE-1:0]  raddr,
    input wclken,
    input wfull,
    input wclk
  );

  // RTL Verilog memory model
  localparam DEPTH = 1<<ADDRSIZE;
  reg [DATASIZE-1:0] mem [0:DEPTH-1];
  assign rdata = mem[raddr];

  always @(posedge wclk)
    if(wclken && !wfull)
      mem[waddr] <= wdata;

endmodule


// --------------------------------------------------------------------
//
module
  cummings_rptr_empty
  #(
    parameter ADDRSIZE = 4
  )
  (
    output reg                  rempty,
    output      [ADDRSIZE-1:0]  raddr,
    output reg  [ADDRSIZE :0]   rptr,
    input       [ADDRSIZE :0]   rq2_wptr,
    input                       rinc,
    input                       rclk,
    input                       rrst_n
  );

  reg [ADDRSIZE:0] rbin;
  wire [ADDRSIZE:0] rgraynext, rbinnext;

  //-------------------
  // GRAYSTYLE2 pointer
  //-------------------
  always @(posedge rclk or negedge rrst_n)
    if(!rrst_n)
      {rbin, rptr} <= 0;
    else
      {rbin, rptr} <= {rbinnext, rgraynext};

  // Memory read-address pointer (okay to use binary to address memory)
  assign raddr = rbin[ADDRSIZE-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext>>1) ^ rbinnext;

  //---------------------------------------------------------------
  // FIFO empty when the next rptr == synchronized wptr or on reset
  //---------------------------------------------------------------
  assign rempty_val = (rgraynext == rq2_wptr);

  always @(posedge rclk or negedge rrst_n)
    if(!rrst_n)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;

endmodule


// --------------------------------------------------------------------
//
module
  cummings_wptr_full
  #(
    parameter ADDRSIZE = 4
  )
  (
    output reg                  wfull,
    output      [ADDRSIZE-1:0]  waddr,
    output reg  [ADDRSIZE :0]   wptr,
    input       [ADDRSIZE :0]   wq2_rptr,
    input                       winc,
    input                       wclk,
    input                       wrst_n
  );

  reg [ADDRSIZE:0] wbin;
  wire [ADDRSIZE:0] wgraynext, wbinnext;

  // GRAYSTYLE2 pointer
  always @(posedge wclk or negedge wrst_n)
    if(!wrst_n)
      {wbin, wptr} <= 0;
    else
      {wbin, wptr} <= {wbinnext, wgraynext};

  // Memory write-address pointer (okay to use binary to address memory)
  assign waddr = wbin[ADDRSIZE-1:0];
  assign wbinnext = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;

  //------------------------------------------------------------------
  // Simplified version of the three necessary full-tests:
  // assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
  // (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
  // (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
  //------------------------------------------------------------------
  assign wfull_val = (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

  always @(posedge wclk or negedge wrst_n)
    if(!wrst_n)
      wfull <= 1'b0;
    else
      wfull <= wfull_val;

endmodule


// --------------------------------------------------------------------
//
module
  cummings_fifo1
  #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
  )
  (
    output [DSIZE-1:0]  rdata,
    output              wfull,
    output              rempty,
    input [DSIZE-1:0]   wdata,
    input               winc,
    input               wclk,
    input               wrst_n,
    input               rinc,
    input               rclk,
    input               rrst_n
  );

  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  cummings_sync_r2w sync_r2w (.wq2_rptr(wq2_rptr), .rptr(rptr),
  .wclk(wclk), .wrst_n(wrst_n));

  cummings_sync_w2r sync_w2r (.rq2_wptr(rq2_wptr), .wptr(wptr),
  .rclk(rclk), .rrst_n(rrst_n));

  cummings_fifomem #(DSIZE, ASIZE) fifomem
  (.rdata(rdata), .wdata(wdata),
  .waddr(waddr), .raddr(raddr),
  .wclken(winc), .wfull(wfull),
  .wclk(wclk));

  cummings_rptr_empty #(ASIZE) rptr_empty
  (.rempty(rempty),
  .raddr(raddr),
  .rptr(rptr), .rq2_wptr(rq2_wptr),
  .rinc(rinc), .rclk(rclk),
  .rrst_n(rrst_n));

  cummings_wptr_full #(ASIZE) wptr_full
  (.wfull(wfull), .waddr(waddr),
  .wptr(wptr), .wq2_rptr(wq2_rptr),
  .winc(winc), .wclk(wclk),
  .wrst_n(wrst_n));

endmodule
// --------------------------------------------------------------------
//


// --------------------------------------------------------------------
//
// --------------------------------------------------------------------


module
  async_fifo
  #(
    W,
    D
  )
  (
    output            wr_full,
    input  [W-1:0]    wr_data,
    input             wr_en,
    input             wr_clk,
    input             wr_reset,

    output            rd_empty,
    output  [W-1:0]   rd_data,
    input             rd_en,
    input             rd_clk,
    input             rd_reset
  );

  // --------------------------------------------------------------------
  //
  cummings_fifo1 #(.DSIZE(W), .ASIZE($clog2(D)))
    cummings_fifo1_i
    (
      .rdata(rd_data),
      .wfull(wr_full),
      .rempty(rd_empty),
      .wdata(wr_data),
      .winc(wr_en),
      .wclk(wr_clk),
      .wrst_n(~wr_reset),
      .rinc(rd_en),
      .rclk(rd_clk),
      .rrst_n(~rd_reset)
    );


// --------------------------------------------------------------------
// synthesis translate_off
  always_ff @(posedge wr_clk)
    if(wr_en & wr_full)
      $stop;
  always_ff @(posedge rd_clk)
    if(rd_en & rd_empty)
      $stop;
// synthesis translate_on
// --------------------------------------------------------------------


// --------------------------------------------------------------------
//
endmodule


