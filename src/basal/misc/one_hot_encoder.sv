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
  one_hot_encoder
  #(
    A=0,  // encoder select width
    D = 2 ** A
  )
  (
    input   [A-1:0] select,
    output  [D-1:0] encoded
  );

  // --------------------------------------------------------------------
  //
  localparam W = 2 ** (A-1);


  // --------------------------------------------------------------------
  //
  generate
    if(A == 1)
    begin: one_hot_encoder_gen
        assign encoded[1:0] = select[0] ? 2'b10 :2'b01;
    end
    else
    begin: recurse_one_hot_encoder_gen
      wire [W-1:0] encoder_out;

      one_hot_encoder #(.A(A - 1))
        one_hot_encoder_i
        (
          .select(select[A-2:0]),
          .encoded(encoder_out)
        );

      assign encoded = select[A-1] ? {encoder_out, {W{1'b0}}} : {{W{1'b0}}, encoder_out};
    end
  endgenerate


// --------------------------------------------------------------------
//
endmodule

