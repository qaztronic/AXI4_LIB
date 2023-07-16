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


interface
  axi4_lite_register_if
  #(
    N   = 8,      //  data bus width in bytes, must be 4 or 8 for axi lite
    MW  = 3,      //  mux select width
    MI  = 2 ** MW //  mux inputs
  );

  wire  [(N*8)-1:0] register_in   [MI-1:0];
  reg   [(N*8)-1:0] register_out  [MI-1:0];
  wire              wr_en         [MI-1:0];
  wire              rd_en         [MI-1:0];
  wire  [(8*N)-1:0] wdata;

// --------------------------------------------------------------------
// synthesis translate_off
    initial
      a_data_bus_width: assert((N == 8) | (N == 4)) else $fatal;
// synthesis translate_on
// --------------------------------------------------------------------

// --------------------------------------------------------------------
//

endinterface


