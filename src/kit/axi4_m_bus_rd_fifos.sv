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

module axi4_m_bus_rd_fifos
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_bus_wr_fifo_if wr_fifo
);
  // --------------------------------------------------------------------
  wire clk   = aclk    ;
  wire reset = ~aresetn;

  // --------------------------------------------------------------------
  assign wr_fifo.ar_rd_en = axi4_s.awready & axi4_s.awvalid;
  assign axi4_s.awready   = ~wr_fifo.ar_wr_full;

  tiny_sync_fifo #(axi4_s.AR_W) ar_fifo
  ( .wr_full (wr_fifo.ar_wr_full )
  , .wr_en   (wr_fifo.ar_wr_en   )
  , .rd_empty(wr_fifo.ar_rd_empty)
  , .rd_en   (wr_fifo.ar_rd_en   )
  , .wr_data (axi4_s.ar_flat_in  )
  , .rd_data (axi4_s.ar_flat_out )
  , .*
  );

  // --------------------------------------------------------------------
  
  // --------------------------------------------------------------------
  //
  wire ar_rd_empty;
  wire ar_rd_en = axi4_m.arready & axi4_m.arvalid;
  assign axi4_m.arvalid = ~ar_rd_empty;

  // sync_fifo #(.W(AR_W), .D(AR_D))
  tiny_sync_fifo #(AR_W)
    ar_fifo
    (
      .wr_full(ar_wr_full),
      .wr_data(ar_wr_data),
      .wr_en(ar_wr_en),
      .rd_empty(ar_rd_empty),
      .rd_data(ar_rd_data),
      .rd_en(ar_rd_en),
      // .count(),
      .clk(aclk),
      .reset(~aresetn)
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
