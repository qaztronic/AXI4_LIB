// --------------------------------------------------------------------
// Copyright 2020 qaztronic
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

import axis_pkg::*;

module axis_test_patern
  #(  axis_cfg_t CONFIG
  ,   int W   // word width in bytes
  ,   int WPB // number of words per beat
  )
  ( axis_if axis_out,
    input   aclk,
    input   aresetn
  );
  // --------------------------------------------------------------------
  localparam N = CONFIG.N;

// --------------------------------------------------------------------
// synthesis translate_off
  initial
  begin
    a_words_per_beat:  assert(N == W * WPB) else $fatal;
    a_wpb: assert((WPB != 0) & ((WPB & (WPB - 1)) == 0)) else $fatal; // power of two
  end
// synthesis translate_on
// --------------------------------------------------------------------

  // --------------------------------------------------------------------
  localparam W_LG = $clog2(W);

  // --------------------------------------------------------------------
  reg [(W*8)-W_LG-1:0] counter;

  always_ff @(posedge aclk)
    if(~aresetn)
      counter <= 0;
    else if(axis_out.tready & axis_out.tvalid)
      counter <= counter + 1;


  // --------------------------------------------------------------------
  //  counter test pattern
  wire [(N*8)-1:0] tp_counter;
  genvar j;

  generate
    for(j = 0; j < WPB; j++)
    begin: counting_test_pattern_gen
      wire [W_LG-1:0] index = j;
      assign tp_counter[j*W*8 +: W*8] = {counter, index};
    end
  endgenerate

  // --------------------------------------------------------------------
  wire [(N*8)-1:0] tp_mux_out = tp_counter;

  // --------------------------------------------------------------------
  assign axis_out.tdata = tp_mux_out;

// --------------------------------------------------------------------
endmodule
