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
  sync_fifo
  #(
    W = 8,
    D = 16,
    UB = $clog2(D)
  )
  (
    output            wr_full,
    input   [W-1:0]   wr_data,
    input             wr_en,
    output            rd_empty,
    output  [W-1:0]   rd_data,
    input             rd_en,
    output  [UB:0]    count,
    input             clk,
    input             reset
  );

  // --------------------------------------------------------------------
  generate
    begin: fifo_gen
      if(D == 2)
      begin
        reg [UB:0] count_r;
        assign count = count_r;

        always_comb
          case({wr_full, rd_empty})
            2'b0_0: count_r = 1;
            2'b0_1: count_r = 0;
            2'b1_0: count_r = 2;
            2'b1_1: count_r = 'x; // should never happen
          endcase

        tiny_sync_fifo #(.W(W))
          tiny_sync_fifo_i(.*);
      end
      else
      begin
        bc_sync_fifo #(.depth(D), .width(W))
          bc_sync_fifo_i
          (
            .wr_enable(wr_en),
            .rd_enable(rd_en),
            .empty(rd_empty),
            .full(wr_full),
            .count(count),
            .*
           );
      end
    end
  endgenerate

// --------------------------------------------------------------------
// synthesis translate_off
  always_ff @(posedge clk)
    if(wr_en & wr_full)
      $stop;
  always_ff @(posedge clk)
    if(rd_en & rd_empty)
      $stop;
// synthesis translate_on
// --------------------------------------------------------------------

// --------------------------------------------------------------------
endmodule
