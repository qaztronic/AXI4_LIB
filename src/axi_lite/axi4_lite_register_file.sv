// --------------------------------------------------------------------
// Copyright qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”);
// you may not use this file except in compliance with the License, or,
// at your option, the Apache License version 2.0. You may obtain a copy
// of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work
// distributed under the License is distributed on an “AS IS” BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.
// --------------------------------------------------------------------

module axi4_lite_register_file #(axi4_lite_pkg::axi4_lite_cfg_t C='{default: 0}, int CLOG2_W=0)
( input  aclk
, input  aresetn
, axi4_lite_if axi4_s
, axi4_lite_register_if r_if
);
import axi4_lite_pkg::*;

  // --------------------------------------------------------------------
  localparam  W = 2 ** CLOG2_W;
  localparam LB = (C.N == 8) ? 3 : 2;
  localparam UB = LB + CLOG2_W - 1;

  // --------------------------------------------------------------------
  axi4_bus_wr_fifo_if wr_fifo(.*);
  wire rf_wr_en = ~wr_fifo.aw_rd_empty & ~wr_fifo.w_rd_empty & ~wr_fifo.b_wr_full;
  assign wr_fifo.aw_rd_en = rf_wr_en;
  assign wr_fifo.w_rd_en  = rf_wr_en;
  assign wr_fifo.b_wr_en  = rf_wr_en;

  axi4_s_bus_wr_fifos axi4_bus_wr_fifos_i(.*);

  // --------------------------------------------------------------------
  assign r_if.wdata = axi4_s._wdata;
  wire register_select [W-1:0];
  genvar j;

  generate
    for(j = 0; j < W; j = j + 1)
    begin: decoder
      assign register_select[j] = (axi4_s._awaddr[UB:LB] == j) ? 1 : 0;
      assign r_if.wr_en[j]      = rf_wr_en & register_select[j];

      always_ff @(posedge aclk)
        if(~aresetn)
          r_if.register_out[j] <= 0;
        else if(r_if.wr_en[j])
          r_if.register_out[j] <= axi4_s._wdata;
    end
  endgenerate

  // // --------------------------------------------------------------------
  // //
  // wire ar_rd_empty;
  // wire r_wr_full;
  // wire rf_rd_en = ~ar_rd_empty & ~r_wr_full;
  // wire ar_rd_en = rf_rd_en;
  // wire r_wr_en = rf_rd_en;

  // axi4_if #(.A(A), .N(N), .I(I))
    // axi4_read_fifo(.*);

  // axi4_s_to_read_fifos #(.A(A), .N(N), .I(I), .USE_ADVANCED_PROTOCOL(0))
    // axi4_s_to_read_fifos_i(.*);

  // --------------------------------------------------------------------
  axi4_bus_rd_fifo_if rd_fifo(.*);
  wire rf_rd_en = ~rd_fifo.ar_rd_empty & ~rd_fifo.r_wr_full;
  assign rd_fifo.ar_rd_en = rf_rd_en;
  assign rd_fifo.r_wr_en  = rf_rd_en;

  axi4_s_bus_rd_fifos axi4_bus_rd_fifos_i(.*);

  // --------------------------------------------------------------------
  wire rd_select [W-1:0];

  generate
    for(j = 0; j < W; j = j + 1)
    begin: rd_en_gen
      assign rd_select [j] = (axi4_s._araddr[UB:LB] == j) ? 1 : 0;
      assign r_if.rd_en[j] = rf_rd_en & rd_select[j];
    end
  endgenerate


  // --------------------------------------------------------------------
  recursive_mux #(.A(CLOG2_W), .W(C.N*8))
    recursive_mux_i
    (
      .select(axi4_s._araddr[UB:LB]),
      .data_in(r_if.register_in),
      .data_out(axi4_s.rdata)
    );


  // // --------------------------------------------------------------------
  // //
  // assign axi4_read_fifo.rid   = 0;
  // assign axi4_read_fifo.rlast = 1;
  assign axi4_s.rresp = 0;


  // // --------------------------------------------------------------------
  // //
  // assign axi4_write_fifo.bid   = 0;
  assign axi4_s.bresp = 0;


// --------------------------------------------------------------------
//

endmodule

