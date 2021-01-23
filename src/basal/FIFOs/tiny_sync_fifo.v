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
  tiny_sync_fifo
  #(
    parameter W
  )
  (
    output  reg       wr_full,
    input   [W-1:0]   wr_data,
    input             wr_en,

    output  reg       rd_empty,
    output  [W-1:0]   rd_data,
    input             rd_en,

    input             clk,
    input             reset
  );

  // --------------------------------------------------------------------
  //
  wire writing = wr_en & ~wr_full;
  wire reading = rd_en & ~rd_empty;


  // --------------------------------------------------------------------
  //
  reg [1:0] rd_ptr_r;
  reg [1:0] next_rd_ptr_r;

  always @(*)
    if(reset)
      next_rd_ptr_r = 0;
    else if(reading)
      next_rd_ptr_r = rd_ptr_r + 1;
    else
      next_rd_ptr_r = rd_ptr_r;

  always @(posedge clk)
    rd_ptr_r <= next_rd_ptr_r;


  // --------------------------------------------------------------------
  //
  reg [1:0] wr_ptr_r;
  reg [1:0] next_wr_ptr_r;

  always @(*)
    if(reset)
      next_wr_ptr_r = 0;
    else if(writing)
      next_wr_ptr_r = wr_ptr_r + 1;
    else
      next_wr_ptr_r = wr_ptr_r;

  always @(posedge clk)
    wr_ptr_r <= next_wr_ptr_r;


  // --------------------------------------------------------------------
  //
  wire empty_w = (next_wr_ptr_r == next_rd_ptr_r);

  always @(posedge clk)
    if(reset)
      rd_empty <= 1;
    else
      rd_empty <= empty_w;


  // --------------------------------------------------------------------
  //
  wire full_w = ({~next_wr_ptr_r[1],next_wr_ptr_r[0]} == next_rd_ptr_r);

  always @(posedge clk)
    if(reset)
      wr_full <= 0;
    else
      wr_full <= full_w;


  // --------------------------------------------------------------------
  //
  reg   [W-1:0] data_0_r;
  reg   [W-1:0] data_1_r;
  wire  [W-1:0] wr_data_mux = rd_ptr_r[0] ? data_1_r : data_0_r;
  assign rd_data = wr_data_mux;

  always @(posedge clk)
    if(writing)
      if(wr_ptr_r[0])
        data_1_r <= wr_data;
      else
        data_0_r <= wr_data;


// --------------------------------------------------------------------
// synthesis translate_off
  always @(posedge clk)
    if(wr_en & wr_full)
      $stop;
  always @(posedge clk)
    if(rd_en & rd_empty)
      $stop;
// synthesis translate_on
// --------------------------------------------------------------------


// --------------------------------------------------------------------
//
endmodule
