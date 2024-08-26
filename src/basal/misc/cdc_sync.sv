// --------------------------------------------------------------------
// Copyright 2024 qaztronic
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

module cdc_sync #(W=3)
( input  in_clk
, input  in
, input  out_clk
, output out
);
// --------------------------------------------------------------------
// synthesis translate_off
  initial assert(W > 1) else $fatal;
// synthesis translate_on
// --------------------------------------------------------------------

  // --------------------------------------------------------------------
  reg in_r;

  always_ff @(posedge in_clk)
    in_r <= in;

  // --------------------------------------------------------------------
  reg [W-1:0] out_r;
  assign out = out_r[0];

  always @(posedge out_clk)
    out_r <= {in_r, out_r[W-1:1]};

// --------------------------------------------------------------------
endmodule
