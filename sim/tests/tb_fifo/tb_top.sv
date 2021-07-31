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

module tb_top;
  timeunit 1ns;
  timeprecision 100ps;
  import uvm_pkg::*;
  import tb_top_pkg::*;
  import axis_pkg::*;
  import fifo_pkg::*;
  `include "uvm_macros.svh"

  // --------------------------------------------------------------------
  localparam realtime PERIODS[1] = '{10ns};
  localparam CLOCK_COUNT = $size(PERIODS);

  // --------------------------------------------------------------------
  bit tb_clk[CLOCK_COUNT];
  wire tb_aresetn;
  bit tb_reset[CLOCK_COUNT];

  tb_base #(.N(CLOCK_COUNT), .PERIODS(PERIODS)) tb(.*);

  // --------------------------------------------------------------------
  wire clk = tb_clk[0];
  wire reset = tb_reset[0];

  // --------------------------------------------------------------------
  fifo_if #(.W(W), .D(D)) dut_if(.*);

  sync_fifo #(.W(W), .D(D))
    dut
    (
      .wr_full(dut_if.wr_full),
      .wr_data(dut_if.wr_data),
      .wr_en(dut_if.wr_en),
      .rd_empty(dut_if.rd_empty),
      .rd_data(dut_if.rd_data),
      .rd_en(dut_if.rd_en),
      .count(dut_if.count),
      .clk(dut_if.clk),
      .reset(dut_if.reset)
    );


  // --------------------------------------------------------------------
  tb_dut_config cfg_h = new(dut_if);

  initial
  begin
    uvm_config_db #(tb_dut_config)::set(null, "*", "tb_dut_config", cfg_h);
    run_test("t_debug");
  end

// --------------------------------------------------------------------
endmodule
