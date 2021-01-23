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
  sync_reset
  #(
    parameter ASSERT_LENGTH = 8
  )
  (
    input clk_in,
    input async_reset_in,
    output sync_reset_out
  );


  // --------------------------------------------------------------------
  reg [(ASSERT_LENGTH-1):0] sync_reset_out_r;
  assign    sync_reset_out = sync_reset_out_r[ASSERT_LENGTH-1];

  always @(posedge clk_in or posedge async_reset_in)
    if(async_reset_in)
      sync_reset_out_r <= {ASSERT_LENGTH{1'b1}};
    else
      sync_reset_out_r <= {sync_reset_out_r[(ASSERT_LENGTH-2):0], 1'b0};

      
endmodule


