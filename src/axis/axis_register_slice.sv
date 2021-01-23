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

module axis_register_slice #(axis_cfg_t CONFIG)
  ( axis_if axis_in
  , axis_if axis_out
  , input aclk
  , input aresetn
  );
  // --------------------------------------------------------------------
  localparam int W  = (CONFIG.N * 8)
                    + (CONFIG.N * CONFIG.USE_TSTRB)
                    + (CONFIG.N * CONFIG.USE_TKEEP)
                    + CONFIG.I
                    + CONFIG.D
                    + CONFIG.U
                    + 1;

  // --------------------------------------------------------------------
  wire          wr_full;
  wire [W-1:0]  wr_data;
  wire          wr_en;

  wire          rd_empty;
  wire [W-1:0]  rd_data;
  wire          rd_en;

  tiny_sync_fifo #(W)
    tiny_sync_fifo_i(.clk(aclk), .reset(~aresetn), .*);

  // --------------------------------------------------------------------
  axis_map_fifo #(CONFIG, W)
    axis_map_fifo_i(.*);

  // --------------------------------------------------------------------
  assign axis_in.tready   = ~wr_full;
  assign wr_en            = axis_in.tvalid & ~wr_full;
  assign axis_out.tvalid  = ~rd_empty;
  assign rd_en            = axis_out.tready & ~rd_empty;

// --------------------------------------------------------------------
endmodule
