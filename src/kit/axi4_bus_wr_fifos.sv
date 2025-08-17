// -----------------------------------------------------------------------------
// Copyright qaztronic    |    SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may
// not use this file except in compliance with the License, or, at your option,
// the Apache License version 2.0. You may obtain a copy of the License at
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law, any work distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the specific language
// governing permissions and limitations under the License.
// -----------------------------------------------------------------------------

module axi4_bus_wr_fifos
( input        aclk
, input        aresetn
, axi4_lite_if axi4_bus
, axi4_bus_wr_fifo_if wr_fifo
);
  // ---------------------------------------------------------------------------
  wire clk   = aclk    ;
  wire reset = ~aresetn;

  // ---------------------------------------------------------------------------
  assign wr_fifo.aw_wr_en = axi4_bus.awready & axi4_bus.awvalid;
  assign wr_fifo.awaddr   = axi4_bus.awaddr;
  assign axi4_bus.awready   = ~wr_fifo.aw_wr_full;

  tiny_sync_fifo #(wr_fifo.AW_W) aw_fifo
  ( .wr_full (wr_fifo.aw_wr_full )
  , .wr_en   (wr_fifo.aw_wr_en   )
  , .rd_empty(wr_fifo.aw_rd_empty)
  , .rd_en   (wr_fifo.aw_rd_en   )
  , .wr_data (wr_fifo.aw_flat_in  )
  , .rd_data (wr_fifo.aw_flat_out )
  , .*
  );

  // ---------------------------------------------------------------------------
  assign wr_fifo.w_wr_en = axi4_bus.wready & axi4_bus.wvalid;
  assign wr_fifo.wdata   = axi4_bus.wdata;
  assign axi4_bus.wready   = ~wr_fifo.w_wr_full;

  tiny_sync_fifo #(wr_fifo.W_W) w_fifo
  ( .wr_full (wr_fifo.w_wr_full )
  , .wr_en   (wr_fifo.w_wr_en   )
  , .rd_empty(wr_fifo.w_rd_empty)
  , .rd_en   (wr_fifo.w_rd_en   )
  , .wr_data (wr_fifo.w_flat_in  )
  , .rd_data (wr_fifo.w_flat_out )
  , .*
  );

  // ---------------------------------------------------------------------------
  assign wr_fifo.b_rd_en = axi4_bus.bready & axi4_bus.bvalid;
  assign axi4_bus.bvalid   = ~wr_fifo.b_rd_empty;

  tiny_sync_fifo #(wr_fifo.B_W) b_fifo
  ( .wr_full (wr_fifo.b_wr_full )
  , .wr_en   (wr_fifo.b_wr_en   )
  , .rd_empty(wr_fifo.b_rd_empty)
  , .rd_en   (wr_fifo.b_rd_en   )
  , .wr_data (wr_fifo.b_flat_in  )
  , .rd_data (wr_fifo.b_flat_out )
  , .*
  );

// -----------------------------------------------------------------------------
endmodule
