// -------------------------------------------------------------------------------
// Copyright qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may
// not use this file except in compliance with the License, or, at your option,
// the Apache License version 2.0. You may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed
// under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
// -------------------------------------------------------------------------------

module top;
import axis_pkg::*;
  timeunit 100ps;
  timeprecision 1ps;
  // --------------------------------------------------------------------
  localparam W = 16;
  localparam H =  8;
  localparam B =  5;
  localparam N =  2;
  localparam U =  3;

  // --------------------------------------------------------------------
  bit clk_100;
  wire aclk = clk_100;
  initial forever #(10ns/2) clk_100 = ~clk_100;

  // --------------------------------------------------------------------
  localparam axis_cfg_t C ='{default: 0, N: N, U: U};
  bit aresetn = 0;
  axis_if #(C) axis_bus(.*);

  wire tvalid = axis_bus.tvalid;
  bit  tready = 1;
  wire sof_out;
  wire sol_out;
  wire eol_out;
  wire eof_out;

  asv_enforcer #(W, H, B)
    dut
    ( .sof_in(axis_bus.tuser[0])
    , .eol_in(axis_bus.tlast   )
    , .*
    );

  // --------------------------------------------------------------------
  assign axis_bus.tready   = tready ;
  assign axis_bus.tuser[1] = sol_out;
  assign axis_bus.tuser[2] = eof_out;

  `include "asv_piker_bfm.svh"

  // --------------------------------------------------------------------
  initial
    fork
    begin
      #10ms;
      $display("[%0t] TimeOut!!!", $time);
      $finish;
    end
    join_none

  // --------------------------------------------------------------------
  initial
  begin
    $display(" ");
    $display("@@@ | %t | running test | ", $time);

    #200ns;
    aresetn = 1;
    #200ns;

    repeat(8) @(posedge aclk);
    send_frame();

    $monitor("### | %t | out | sof = %0h| sol = %0h | eol = %0h | eof = %0h"
            , $time
            , sof_out
            , sol_out
            , eol_out
            , eof_out
            );

    repeat(8) @(posedge aclk);
    $display("@@@ | %t | test done!!! | ", $time);

    $finish;
  end

// --------------------------------------------------------------------
endmodule
