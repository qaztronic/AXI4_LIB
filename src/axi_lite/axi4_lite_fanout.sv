// --------------------------------------------------------------------
// Copyright 2021 qaztronic
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

module axi4_lite_fanout
#( int         A=0
,  int         N=0
,  bit [A-1:0] M=0
,  int         I=1
)
( axi4_if axi4_s
, axi4_if axi4_m[2]
, input   aclk
, input   aresetn
);
  // --------------------------------------------------------------------
  axi4_lite_fanout_wr #(A, N, M, I)
    axi4_lite_fanout_wr_i(.*);

  // --------------------------------------------------------------------
  axi4_lite_fanout_rd #(A, N, M, I)
    axi4_lite_fanout_rd_i(.*);

// --------------------------------------------------------------------
endmodule
