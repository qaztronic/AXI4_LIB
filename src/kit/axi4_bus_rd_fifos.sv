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

module axi4_bus_rd_fifos
( input        aclk
, input        aresetn
, axi4_lite_if axi4_bus
, axi4_bus_rd_fifo_if rd_fifo
);
  // ---------------------------------------------------------------------------
  wire clk   = aclk    ;
  wire reset = ~aresetn;

  // ---------------------------------------------------------------------------
  assign rd_fifo.ar_wr_en = axi4_bus.arready & axi4_bus.arvalid;
  assign rd_fifo.araddr   = axi4_bus.araddr;
  assign axi4_bus.arready   = ~rd_fifo.ar_wr_full;

  tiny_sync_fifo #(rd_fifo.AR_W) ar_fifo
  ( .wr_full (rd_fifo.ar_wr_full  )
  , .wr_en   (rd_fifo.ar_wr_en    )
  , .rd_empty(rd_fifo.ar_rd_empty )
  , .rd_en   (rd_fifo.ar_rd_en    )
  , .wr_data (rd_fifo.ar_flat_in  )
  , .rd_data (rd_fifo.ar_flat_out )
  , .*
  );

  // ---------------------------------------------------------------------------
  assign rd_fifo.r_rd_en = axi4_bus.rready & axi4_bus.rvalid;
  assign axi4_bus.rdata    = rd_fifo._rdata;
  assign axi4_bus.rresp    = rd_fifo._rresp;
  assign axi4_bus.rvalid   = ~rd_fifo.r_rd_empty;

  tiny_sync_fifo #(rd_fifo.R_W) r_fifo
  ( .wr_full (rd_fifo.r_wr_full  )
  , .wr_en   (rd_fifo.r_wr_en    )
  , .rd_empty(rd_fifo.r_rd_empty )
  , .rd_en   (rd_fifo.r_rd_en    )
  , .wr_data (rd_fifo.r_flat_in  )
  , .rd_data (rd_fifo.r_flat_out )
  , .*
  );

// -----------------------------------------------------------------------------
endmodule
