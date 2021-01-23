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

module axis_checker
#(  axis_cfg_t CONFIG
,   MAXWAITS     = 16
,   RecommendOn  = 1'b1
,   RecMaxWaitOn = 1'b1
)
(   axis_if axis_in
);
  //---------------------------------------------------
  localparam DATA_WIDTH_BYTES = CONFIG.N;         // data bus width
  localparam DEST_WIDTH = CONFIG.D;               // TDEST width

  // Select the number of ID bits required
  localparam ID_WIDTH = CONFIG.I;                 // (T)ID width

  // Select the size of the USER buses
  localparam USER_WIDTH  = CONFIG.U;            // width of the user sideband field

  //---------------------------------------------------
  // INDEX:        - Calculated (user should not override)
  // =====
  // Do not override the following parameters: they must be calculated exactly
  // as shown below
  // data max index
  localparam    DATA_MAX = DATA_WIDTH_BYTES ? (DATA_WIDTH_BYTES*8)-1:0;
  localparam    DEST_MAX = DEST_WIDTH ? DEST_WIDTH-1:0;    // dest max index
  localparam  STRB_WIDTH = DATA_WIDTH_BYTES;               // TSTRB width
  localparam    STRB_MAX = STRB_WIDTH ? STRB_WIDTH-1:0;    // TSTRB max index
  localparam    KEEP_MAX = STRB_WIDTH ? STRB_WIDTH-1:0;    // TKEEP max index
  localparam      ID_MAX = ID_WIDTH ? ID_WIDTH-1:0;        // ID max index
  localparam   TUSER_MAX = USER_WIDTH? USER_WIDTH-1:0;   // TUSER  max index

  //---------------------------------------------------
  // INDEX:        - Global Signals
  // =====
  wire                ACLK = axis_in.aclk;        // AXI Clock
  wire                ARESETn = axis_in.aresetn;     // AXI Reset

  // INDEX:        - AXI4-Stream Interface
  // =====
  wire   [DATA_MAX:0] TDATA = axis_in.tdata;
  wire   [STRB_MAX:0] TSTRB = axis_in.tstrb;
  wire   [KEEP_MAX:0] TKEEP = axis_in.tkeep;
  wire                TLAST = axis_in.tlast;
  wire     [ID_MAX:0] TID = axis_in.tid;
  wire   [DEST_MAX:0] TDEST = axis_in.tdest;
  wire  [TUSER_MAX:0] TUSER = axis_in.tuser;
  wire                TVALID = axis_in.tvalid;
  wire                TREADY = axis_in.tready;

  //---------------------------------------------------
  Axi4StreamPC
    #(
                                             // Set DATA_WIDTH to the data-bus width required
      .DATA_WIDTH_BYTES(DATA_WIDTH_BYTES),   // data bus width
      .DEST_WIDTH(DEST_WIDTH),               // TDEST width

                                             // Select the number of ID bits required
      .ID_WIDTH(ID_WIDTH),                   // (T)ID width

                                             // Select the size of the USER buses
      .USER_WIDTH(USER_WIDTH),               // width of the user sideband field

                                             // Maximum number of cycles between VALID -> READY high before a warning is
                                             // generated
      .MAXWAITS(MAXWAITS),

                                             // Recommended Rules Enable
                                             // enable/disable reporting of all  AXI4STREAM_REC*_* rules
      .RecommendOn(RecommendOn),
                                             // enable/disable reporting of just AXI4STREAM_REC*_MAX_WAIT rules
      .RecMaxWaitOn(RecMaxWaitOn)
    )
    Axi4StreamPC_i(.*);

//---------------------------------------------------
endmodule
