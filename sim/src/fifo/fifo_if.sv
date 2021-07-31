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

interface
  fifo_if
  #(
    W,
    D,
    UB = $clog2(D)
  )
  (
    input reset,
    input clk
  );
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  // import tb_top_pkg::*;

  // --------------------------------------------------------------------
  wire          wr_full;
  wire  [W-1:0] wr_data;
  wire          wr_en;
  wire          rd_empty;
  wire  [W-1:0] rd_data;
  wire          rd_en;
  wire  [UB:0]  count;

  // --------------------------------------------------------------------
  default clocking cb @(posedge clk);
    input reset;
    input wr_full;
    input rd_empty;
    input rd_data;
    input count;
    inout rd_en;
    inout wr_en;
    inout wr_data;
  endclocking

  // --------------------------------------------------------------------
  task zero_cycle_delay;
    ##0;
  endtask: zero_cycle_delay

// --------------------------------------------------------------------
endinterface
