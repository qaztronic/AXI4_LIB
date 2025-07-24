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

module axi4_s_bus_rd_fifos
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_bus_rd_fifo_if rd_fifo
);
  // --------------------------------------------------------------------
  wire clk   = aclk    ;
  wire reset = ~aresetn;

  // --------------------------------------------------------------------
  assign rd_fifo.ar_wr_en = axi4_s.arready & axi4_s.arvalid;
  assign axi4_s.arready   = ~rd_fifo.ar_wr_full;

  tiny_sync_fifo #(axi4_s.AR_W) ar_fifo
  ( .wr_full (rd_fifo.ar_wr_full )
  , .wr_en   (rd_fifo.ar_wr_en   )
  , .rd_empty(rd_fifo.ar_rd_empty)
  , .rd_en   (rd_fifo.ar_rd_en   )
  , .wr_data (axi4_s.ar_flat_in  )
  , .rd_data (axi4_s.ar_flat_out )
  , .*
  );

  // --------------------------------------------------------------------
  assign rd_fifo.r_rd_en = axi4_s.rready & axi4_s.rvalid;
  assign axi4_s.rvalid   = ~rd_fifo.r_rd_empty;

  tiny_sync_fifo #(axi4_s.R_W) r_fifo
  ( .wr_full (rd_fifo.r_wr_full )
  , .wr_en   (rd_fifo.r_wr_en   )
  , .rd_empty(rd_fifo.r_rd_empty)
  , .rd_en   (rd_fifo.r_rd_en   )
  , .wr_data (axi4_s.r_flat_in  )
  , .rd_data (axi4_s.r_flat_out )
  , .*
  );

// --------------------------------------------------------------------
endmodule
