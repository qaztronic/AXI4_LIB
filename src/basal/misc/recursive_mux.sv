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
  recursive_mux
  #(
    A,  // mux select width
    W, // data width
    D = 2 ** A
  )
  (
    input   [A-1:0] select,
    input   [W-1:0] data_in [D-1:0],
    output  [W-1:0] data_out
  );

  // --------------------------------------------------------------------
  //
  generate
    if(A == 1)
    begin: mux_gen
        assign data_out = select ? data_in[1] : data_in[0];
    end
    else
    begin: recurse_mux_gen
      wire [W-1:0] data_out_lo, data_out_hi;

      recursive_mux #(.A(A - 1), .W(W))
        mux_lo
        (
          .select(select[A-2:0]),
          .data_in(data_in[(D/2)-1:0]),
          .data_out(data_out_lo)
        );

      recursive_mux #(.A(A - 1), .W(W))
        mux_hi
        (
          .select(select[A-2:0]),
          .data_in(data_in[D-1:(D/2)]),
          .data_out(data_out_hi)
        );

      assign data_out = select[A-1] ? data_out_hi : data_out_lo;
    end
  endgenerate



// --------------------------------------------------------------------
//

endmodule

