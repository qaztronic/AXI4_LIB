// --------------------------------------------------------------------
// Copyright 2024 qaztronic
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
import axi4_lite_piker_bfm_pkg::*;
  // --------------------------------------------------------------------
  bit aresetn = 0;
  bit aclk;
  initial forever #(10ns/2) aclk = ~aclk;

  // --------------------------------------------------------------------
  localparam A  =     16;
  localparam N  =      4;
  localparam I  =      1;
  localparam M  = 'h0100;
  localparam MW =      4;

  axi4_if #(A, N) axi4_s(.*);
  axi4_if #(A, N) axi4_m[2](.*);
  axi4_lite_piker_bfm_if #(A, N) vif(.*);

  // --------------------------------------------------------------------
  axi4_lite_register_if #(N, MW) r_if[2]();
  assign r_if[0].register_in = r_if[0].register_out;
  assign r_if[1].register_in = r_if[1].register_out;

  axi4_lite_fanout #(A, N, M, I)
    dut(.*);

  axi4_lite_register_file #(A, N, I, MW)
    reg_file_0(.axi4_s(axi4_m[0]), .r_if(r_if[0]), .*);

  axi4_lite_register_file #(A, N, I, MW)
    reg_file_1(.axi4_s(axi4_m[1]), .r_if(r_if[1]), .*);

  // --------------------------------------------------------------------
   initial
   begin
    #10us;
    $warning("[%10t] Timeout!...", $time);
    $finish;
   end

  // --------------------------------------------------------------------
  bit [    A-1:0] addr;
  bit [(N*8)-1:0] data;
  // bit [(N*8)-1:0] da_0[];
  // bit [(N*8)-1:0] da_1[];
  axi4_lite_piker_bfm_transaction #(A, N) tr;
  axi4_lite_piker_bfm_driver #(A, N) bfm;

  initial
  begin
    // ........................................................................
    $display("[%10t] Model running...", $time);

    bfm = new(vif);

    repeat(4) @(posedge aclk);
    aresetn = 1;
    $display("[%10t] reset deasserted...", $time);

    repeat(8) @(posedge aclk);

    // bfm.read ('h04, data       );
    // bfm.read ('h04, data       );

    repeat(8) @(posedge aclk);

    // bfm.axi4_lite_read ('h04, data       );
    // bfm.axi4_lite_write('h04, 'habba_beef);
    // bfm.axi4_lite_read ('h04, data       );

    // ........................................................................
    repeat(8)
    begin
      tr = new();
      void'(tr.randomize());
      $display("[%10t] axaddr: %08x", $time, tr.axaddr);
    end

    // // ........................................................................
    // da_0 = new[8];
    // // randomize(da_0);
    // foreach(da_0[i]) da_0[i] = $urandom;

    // foreach(da_0[i])
      // bfm.axi4_lite_write(16'(i*4), da_0[i]);

    // da_1 = new[8];
    // // randomize(da_1);
    // foreach(da_1[i]) da_1[i] = $urandom;

    // foreach(da_1[i])
      // bfm.axi4_lite_write(16'(M + (i*4)), da_1[i]);

    // foreach(da_0[i])
    // begin
      // bfm.axi4_lite_read(16'(i*4), data);
      // if(data != da_0[i]) $warning("[%10t] | data mismatch @ 0x%8x", $time, i*4);
    // end

    // foreach(da_1[i])
    // begin
      // bfm.axi4_lite_read(16'(M + (i*4)), data);
      // if(data != da_1[i]) $warning("[%10t] | data mismatch @ 0x%8x", $time, M + (i*4));
    // end

    // ........................................................................
    $display("[%10t] Test done!...", $time);
    $finish;
  end

// --------------------------------------------------------------------
endmodule

