// --------------------------------------------------------------------
// Copyright 2020 qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License");
// you may not use this file except in compliance with the License, or,
// at your option, the Apache License version 2.0. You may obtain a copy
// of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.
// --------------------------------------------------------------------

module axi4_lite_read_dpm  #(A, N, I = 1, W = N*8, LB = (N == 8) ? 3 : 2)
( axi4_if           axi4_s
, input             aclk
, input             aresetn
, input             b_clk
, input             b_wr
, input  [A-1-LB:0] b_addr
, input  [W-1:0]    b_din
, output [W-1:0]    b_dout
);
// --------------------------------------------------------------------
// synthesis translate_off
  initial
  begin
    assert(A - LB > 0) else $fatal;
  end
// synthesis translate_on
// --------------------------------------------------------------------

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
  wire         a_wr  = 0;
  wire [W-1:0] a_din = 0;

  bram_tdp #(N*8, A-LB)
    bram_tdp_i
    ( .a_clk (aclk                         )
    , .a_addr(axi4_read_fifo.araddr[A-1:LB])
    , .a_dout(axi4_read_fifo.rdata         )
    , .*
    );

  // --------------------------------------------------------------------
  assign axi4_read_fifo.rid   = 0;
  assign axi4_read_fifo.rlast = 1;
  assign axi4_read_fifo.rresp = 0;
  assign axi4_s.awready = 1;
  assign axi4_s.bid     = 0;
  assign axi4_s.bresp   = 0;
  assign axi4_s.bvalid  = 1;
  assign axi4_s.wready  = 1;

// --------------------------------------------------------------------
endmodule
