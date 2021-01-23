//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2019 Authors and OPENCORES.ORG                 ////
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
  barrel_shifter
  #(
    parameter W = 32,
    parameter D = W,
    parameter UB = $clog2(D)
  )
  (
    input  direction,       // right = 0, left = 1
    input  op,              // logical = 0, arithmetic = 1; left arithmetic not supported
    input [UB-1:0] amount,  // 0 not allowed
    input [W-1:0] data_in,
    output [W-1:0] data_out,

    input reset,
    input clk
  );

  // --------------------------------------------------------------------
  wire [W-1:0] out [UB:0];
  wire shift_in = direction & op ? data_in[W-1] : 0;
  genvar j, k;

  // --------------------------------------------------------------------
  generate
    for(k = 0; k < D; k = k + 1)
    begin : reversal
      assign out[5][k] = direction ? data_in[k] : data_in[D - 1 - k];
      assign data_out[k] = direction ? out[0][k] : out[0][D - 1 - k];
    end
  endgenerate

  // --------------------------------------------------------------------
  generate
    for(j = 0; j < UB; j = j + 1)
      for(k = 0; k < D; k = k + 1)
      begin : shifter
        if(k > D - 1 - (2**j))
          assign out[j][k] = amount[j] ? shift_in : out[j+1][k];
        else
          assign out[j][k] = amount[j] ? out[j+1][k + (2**j)] : out[j+1][k];
      end
  endgenerate

// --------------------------------------------------------------------
endmodule
