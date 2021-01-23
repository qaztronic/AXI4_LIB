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



// --------------------------------------------------------------------
// A parameterized, inferable, true dual-port, dual-clock block RAM in Verilog.

module
  bram_tdp
  #(
    parameter W,
    parameter A
  )
  (
    // Port A
    input               a_clk,
    input               a_wr,
    input       [A-1:0] a_addr,
    input       [W-1:0] a_din,
    output  reg [W-1:0] a_dout,

    // Port B
    input               b_clk,
    input               b_wr,
    input       [A-1:0] b_addr,
    input       [W-1:0] b_din,
    output  reg [W-1:0] b_dout
  );

  // --------------------------------------------------------------------
  // Shared memory
  reg [W-1:0] mem [(2**A)-1:0];


  // --------------------------------------------------------------------
  // Port A
  always @(posedge a_clk)
  if(a_wr)
  begin
    a_dout      <= a_din;
    mem[a_addr] <= a_din;
  end
  else
    a_dout      <= mem[a_addr];


  // --------------------------------------------------------------------
  // Port B
  always @(posedge b_clk)
  if(b_wr)
  begin
    b_dout      <= b_din;
    mem[b_addr] <= b_din;
  end
  else
    b_dout      <= mem[b_addr];


// --------------------------------------------------------------------
//
endmodule

