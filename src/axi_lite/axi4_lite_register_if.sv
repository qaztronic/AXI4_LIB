// --------------------------------------------------------------------
// Copyright qaztronic
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

/* verilator lint_off UNUSEDSIGNAL */
interface axi4_lite_register_if #(axi4_lite_pkg::axi4_lite_cfg_t C='{default: 0}, int CLOG2_W=0, int W=2 ** CLOG2_W)
( input aclk
, input aresetn
);
  // --------------------------------------------------------------------
  wire  [(C.N*8)-1:0] register_in   [W-1:0];
  reg   [(C.N*8)-1:0] register_out  [W-1:0];
  wire                wr_en         [W-1:0];
  wire                rd_en         [W-1:0];
  wire  [(8*C.N)-1:0] wdata;

  // --------------------------------------------------------------------
  // synthesis translate_off
  initial if( ~((C.N == 8) | (C.N == 4)) ) $error("!!! | %m | ~(N == 8) | (N == 4) but N = %0d", C.N);
  // synthesis translate_on
  // --------------------------------------------------------------------

/* verilator lint_on UNUSEDSIGNAL */
// --------------------------------------------------------------------
endinterface
