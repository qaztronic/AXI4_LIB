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
  axi4_lite_register_file
  #(
    A=0,  //  address bus width, must be 32 or greater for axi lite
    N=0,  //  data bus width in bytes, must be 4 or 8 for axi lite
    I=1,  //  ID width
    MW=0  //  mux select width
  )
  (
    axi4_if               axi4_s,
    axi4_lite_register_if r_if,
    input                 aclk,
    input                 aresetn
  );

  // --------------------------------------------------------------------
  //
  localparam MI = 2 ** MW; //  mux inputs
  localparam LB = (N == 8) ? 3 : 2;
  localparam UB = LB + MW - 1;


  // --------------------------------------------------------------------
  //
  wire aw_rd_empty;
  wire w_rd_empty;
  wire b_wr_full;
  wire rf_wr_en = ~aw_rd_empty & ~w_rd_empty & ~b_wr_full;
  wire aw_rd_en = rf_wr_en;
  wire w_rd_en = rf_wr_en;
  wire b_wr_en = rf_wr_en;

  axi4_if #(.A(A), .N(N), .I(I))
    axi4_write_fifo(.*);

  axi4_s_to_write_fifos #(.A(A), .N(N), .I(I), .USE_ADVANCED_PROTOCOL(0))
    axi4_s_to_write_fifos_i(.*);


  // --------------------------------------------------------------------
  //
  assign r_if.wdata = axi4_write_fifo.wdata;
  wire register_select [MI-1:0];
  genvar j;

  generate
    for(j = 0; j < MI; j = j + 1)
    begin: decoder_gen
      assign register_select[j] = (axi4_write_fifo.awaddr[UB:LB] == j) ? 1 : 0;
      assign r_if.wr_en[j]      = rf_wr_en & register_select[j];

      always_ff @(posedge aclk)
        if(~aresetn)
          r_if.register_out[j] <= 0;
        else if(r_if.wr_en[j])
          r_if.register_out[j] <= axi4_write_fifo.wdata;
    end
  endgenerate


  // --------------------------------------------------------------------
  //
  wire ar_rd_empty;
  wire r_wr_full;
  wire rf_rd_en = ~ar_rd_empty & ~r_wr_full;
  wire ar_rd_en = rf_rd_en;
  wire r_wr_en = rf_rd_en;

  axi4_if #(.A(A), .N(N), .I(I))
    axi4_read_fifo(.*);

  axi4_s_to_read_fifos #(.A(A), .N(N), .I(I), .USE_ADVANCED_PROTOCOL(0))
    axi4_s_to_read_fifos_i(.*);


  // --------------------------------------------------------------------
  //
  wire rd_select [MI-1:0];

  generate
    for(j = 0; j < MI; j = j + 1)
    begin: rd_en_gen
      assign rd_select[j] = (axi4_read_fifo.araddr[UB:LB] == j) ? 1 : 0;
      assign r_if.rd_en[j] = rf_rd_en & rd_select[j];
    end
  endgenerate


  // --------------------------------------------------------------------
  //
  recursive_mux #(.A(MW), .W(N*8))
    recursive_mux_i
    (
      .select(axi4_read_fifo.araddr[UB:LB]),
      .data_in(r_if.register_in),
      .data_out(axi4_read_fifo.rdata)
    );


  // --------------------------------------------------------------------
  //
  assign axi4_read_fifo.rid   = 0;
  assign axi4_read_fifo.rlast = 1;
  assign axi4_read_fifo.rresp = 0;


  // --------------------------------------------------------------------
  //
  assign axi4_write_fifo.bid   = 0;
  assign axi4_write_fifo.bresp = 0;


// --------------------------------------------------------------------
//

endmodule

