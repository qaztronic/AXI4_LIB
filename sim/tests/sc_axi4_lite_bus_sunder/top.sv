// -----------------------------------------------------------------------------
// Copyright qaztronic    |    SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may
// not use this file except in compliance with the License, or, at your option,
// the Apache License version 2.0. You may obtain a copy of the License at
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law, any work distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the specific language
// governing permissions and limitations under the License.
// -----------------------------------------------------------------------------

module top;
import axi4_lite_pkg::*;
  // ---------------------------------------------------------------------------
  bit aresetn = 0;
  bit aclk;
  initial forever #(10ns/2) aclk = ~aclk;

  // ---------------------------------------------------------------------------
  localparam A =    16;
  localparam N =     4;
  localparam M = 'h100;

  // ---------------------------------------------------------------------------
  localparam axi4_lite_cfg_t C = '{default: 0, A: A, N: N};
  axi4_lite_if #(C) axi4_s(.*);
  axi4_lite_if #(C) axi4_m[2](.*);

  `include "axi4_lite_piker_bfm.svh"

  // ---------------------------------------------------------------------------
  axi4_lite_bus_sunder #(C, M)
    dut(.*);

  axi4_lite_terminus #(C, 'h1111_1111) stub_0(.axi4_s(axi4_m[0]), .*);
  axi4_lite_terminus #(C, 'hbbbb_bbbb) stub_1(.axi4_s(axi4_m[1]), .*);


  // ---------------------------------------------------------------------------
   initial
   begin
    #300ns;
    $warning("[%10t] Timeout!...", $time);
    $finish;
   end

  // ---------------------------------------------------------------------------
/* verilator lint_off UNUSEDSIGNAL */
  bit [(C.N*8)-1:0] data;
/* verilator lint_on UNUSEDSIGNAL */

  initial
  begin
    // .........................................................................
    $display("[%10t] Model running...", $time);

    repeat(4) @(posedge aclk);
    aresetn = 1;
    $display("[%10t] reset deasserted...", $time);

    repeat(8) @(posedge aclk);

    axi4_lite_read('h004, data);
    axi4_lite_read('h100, data);
    // axi4_lite_write('h04, 'habba_beef);

    repeat(8) @(posedge aclk);

    // .........................................................................
    $display("[%10t] Test done!...", $time);
    $finish;
  end

// -----------------------------------------------------------------------------
endmodule

