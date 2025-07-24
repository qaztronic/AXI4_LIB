// --------------------------------------------------------------------
// Copyright qaztronic
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

module axi4_bus_fifo
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_lite_if axi4_m
// , axi4_bus_fifo_if bus_fifo
);
  // --------------------------------------------------------------------
  wire [axi4_s.AR_W-1:0] ar_flat;
  wire [ axi4_s.B_W-1:0]  b_flat;
  wire [ axi4_s.R_W-1:0]  r_flat;
  wire [ axi4_s.W_W-1:0]  w_flat;
  
  // --------------------------------------------------------------------
  wire aw_rd_en;
  wire aw_rd_empty;
  wire aw_wr_full;
  wire aw_wr_en = axi4_s.awready & axi4_s.awvalid;
  assign axi4_s.awready = ~aw_wr_full;

  tiny_sync_fifo #(axi4_s.AW_W) aw_fifo
  ( .wr_full (aw_wr_full        )
  , .wr_data (axi4_s.aw_flat_in )
  , .wr_en   (aw_wr_en          )
  , .rd_empty(aw_rd_empty       )
  , .rd_data (axi4_s.aw_flat_out)
  , .rd_en   (aw_rd_en          )
  , .clk     (aclk              )
  , .reset   (~aresetn          )
  );

// --------------------------------------------------------------------
endmodule
