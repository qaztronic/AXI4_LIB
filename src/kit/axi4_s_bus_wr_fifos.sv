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

module axi4_s_bus_wr_fifos
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_bus_wr_fifo_if wr_fifo
);
  // --------------------------------------------------------------------
  wire clk   = aclk    ;
  wire reset = ~aresetn;

  // --------------------------------------------------------------------
  assign wr_fifo.aw_wr_en = axi4_s.awready & axi4_s.awvalid;
  assign axi4_s.awready   = ~wr_fifo.aw_wr_full;

  tiny_sync_fifo #(axi4_s.AW_W) aw_fifo
  ( .wr_full (wr_fifo.aw_wr_full )
  , .wr_en   (wr_fifo.aw_wr_en   )
  , .rd_empty(wr_fifo.aw_rd_empty)
  , .rd_en   (wr_fifo.aw_rd_en   )
  , .wr_data (axi4_s.aw_flat_in  )
  , .rd_data (axi4_s.aw_flat_out )
  , .*
  );

  // --------------------------------------------------------------------
  assign wr_fifo.w_wr_en = axi4_s.wready & axi4_s.wvalid;
  assign axi4_s.wready   = ~wr_fifo.w_wr_full;

  tiny_sync_fifo #(axi4_s.W_W) w_fifo
  ( .wr_full (wr_fifo.w_wr_full )
  , .wr_en   (wr_fifo.w_wr_en   )
  , .rd_empty(wr_fifo.w_rd_empty)
  , .rd_en   (wr_fifo.w_rd_en   )
  , .wr_data (axi4_s.w_flat_in  )
  , .rd_data (axi4_s.w_flat_out )
  , .*
  );

  // --------------------------------------------------------------------
  assign wr_fifo.b_rd_en = axi4_s.bready & axi4_s.bvalid;
  assign axi4_s.bvalid   = ~wr_fifo.b_rd_empty;

  tiny_sync_fifo #(axi4_s.B_W) b_fifo
  ( .wr_full (wr_fifo.b_wr_full )
  , .wr_en   (wr_fifo.b_wr_en   )
  , .rd_empty(wr_fifo.b_rd_empty)
  , .rd_en   (wr_fifo.b_rd_en   )
  , .wr_data (axi4_s.b_flat_in  )
  , .rd_data (axi4_s.b_flat_out )
  , .*
  );

// --------------------------------------------------------------------
endmodule
