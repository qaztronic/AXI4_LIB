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
interface axi4_bus_wr_fifo_if
( input aclk
, input aresetn
);
  // --------------------------------------------------------------------
  wire aw_rd_en;
  wire aw_rd_empty;
  wire aw_wr_en;
  wire aw_wr_full;

  // --------------------------------------------------------------------
  wire w_wr_full ;
  wire w_wr_en   ;
  wire w_rd_empty;
  wire w_rd_en   ;

  // --------------------------------------------------------------------
  wire b_wr_full ;
  wire b_wr_en   ;
  wire b_rd_empty;
  wire b_rd_en   ;

/* verilator lint_on UNUSEDSIGNAL */
// --------------------------------------------------------------------
endinterface
