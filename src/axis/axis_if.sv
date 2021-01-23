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

import axis_pkg::*;

`define USE_MOD_PORTS;

interface axis_if #(axis_cfg_t CONFIG)
( input aclk
, input aresetn
);
  // --------------------------------------------------------------------
  localparam int N = CONFIG.N;
  localparam int I = CONFIG.I > 0 ? CONFIG.I : 1;
  localparam int D = CONFIG.D > 0 ? CONFIG.D : 1;
  localparam int U = CONFIG.U > 0 ? CONFIG.U : 1;

  // --------------------------------------------------------------------
  wire              tvalid;
  wire              tready;
  wire  [(8*N)-1:0] tdata;
  wire  [N-1:0]     tstrb;
  wire  [N-1:0]     tkeep;
  wire              tlast;
  wire  [I-1:0]     tid;
  wire  [D-1:0]     tdest;
  wire  [U-1:0]     tuser;

// --------------------------------------------------------------------
// synthesis translate_off
  default clocking cb_m @(posedge aclk);
    input   aresetn;
    output  tvalid;
    input   tready;
    output  tdata;
    output  tstrb;
    output  tkeep;
    output  tlast;
    output  tid;
    output  tdest;
    output  tuser;
  endclocking

  // --------------------------------------------------------------------
  clocking cb_s @(posedge aclk);
    input   aresetn;
    input   tvalid;
    output  tready;
    input   tdata;
    input   tstrb;
    input   tkeep;
    input   tlast;
    input   tid;
    input   tdest;
    input   tuser;
  endclocking
// synthesis translate_on
// --------------------------------------------------------------------

  // --------------------------------------------------------------------
  //
`ifdef USE_MOD_PORTS
    modport
      master
      (
// --------------------------------------------------------------------
// synthesis translate_off
          clocking  cb_m,
// synthesis translate_on
// --------------------------------------------------------------------
        input     aresetn,
        input     aclk,
        output    tvalid,
        input     tready,
        output    tdata,
        output    tstrb,
        output    tkeep,
        output    tlast,
        output    tid,
        output    tdest,
        output    tuser
      );

    // --------------------------------------------------------------------
    modport
      slave
      (
// --------------------------------------------------------------------
// synthesis translate_off
          clocking  cb_s,
// synthesis translate_on
// --------------------------------------------------------------------
        input     aresetn,
        input     aclk,
        input     tvalid,
        output    tready,
        input     tdata,
        input     tstrb,
        input     tkeep,
        input     tlast,
        input     tid,
        input     tdest,
        input     tuser
      );
`endif

// --------------------------------------------------------------------
// synthesis translate_off
  task zero_cycle_delay;
    ##0;
  endtask: zero_cycle_delay
// synthesis translate_on
// --------------------------------------------------------------------

// --------------------------------------------------------------------
endinterface
