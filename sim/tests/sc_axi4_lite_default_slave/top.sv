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

module top;
  // --------------------------------------------------------------------
  bit aresetn = 0;
  bit aclk;
  initial forever #(10ns/2) aclk = ~aclk;

  // --------------------------------------------------------------------
  localparam A = 16;
  localparam N = 4;
  
  axi4_if #(A,N) axi4_s(.*);
  
  `include "axi4_lite_piker_bfm.svh"

  // --------------------------------------------------------------------
  // module axi4_lite_default_slave #(A, N, I=1, D='hbaadc0de)
  
  axi4_lite_default_slave
    dut(.*);
  
  // --------------------------------------------------------------------
  bit [    A-1:0] addr;
  bit [(N*8)-1:0] data;
  
   initial
   begin
      $display("[%10t] Model running...", $time);

      repeat(4) @(posedge aclk);
      aresetn = 1;
      $display("[%10t] reset deasserted...", $time);

      repeat(8) @(posedge aclk);
      
      axi4_lite_read ('h04, data       );
      axi4_lite_write('h04, 'habba_beef);
      axi4_lite_read ('h04, data       );

      $display("[%10t] Test done!...", $time);
      $finish;
   end

// --------------------------------------------------------------------
endmodule
