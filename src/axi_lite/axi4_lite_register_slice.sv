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

module axi4_lite_register_slice #(axi4_lite_pkg::axi4_lite_cfg_t C='{default: 0})
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_lite_if axi4_m
);
  // --------------------------------------------------------------------
  // localparam C = axi4_s.C;
  wire clk     = aclk    ;
  wire reset   = ~aresetn;

  `include "axi4_lite_types.svh"

  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  axi4_bus_wr_fifo_if #(C) wr_fifo_if(.*);

  // ---------------------------------------------------------------------------
  assign wr_fifo_if.aw_wr_en = axi4_s.awready & axi4_s.awvalid;
  assign wr_fifo_if.aw_rd_en = axi4_m.awready & axi4_m.awvalid;
  assign wr_fifo_if.awaddr   = axi4_s.awaddr                  ;
  assign axi4_s.awready      = ~wr_fifo_if.aw_wr_full         ;
  assign axi4_m.awvalid      = ~wr_fifo_if.aw_rd_empty        ;
  assign axi4_m.awaddr       =  wr_fifo_if._awaddr            ;

  tiny_sync_fifo #(AW_W) aw_fifo
  ( .wr_full (wr_fifo_if.aw_wr_full )
  , .wr_en   (wr_fifo_if.aw_wr_en   )
  , .rd_empty(wr_fifo_if.aw_rd_empty)
  , .rd_en   (wr_fifo_if.aw_rd_en   )
  , .wr_data (wr_fifo_if.aw_flat_in )
  , .rd_data (wr_fifo_if.aw_flat_out)
  , .*
  );

  // ---------------------------------------------------------------------------
  assign wr_fifo_if.w_wr_en = axi4_s.wready & axi4_m.wvalid;
  assign wr_fifo_if.w_rd_en = axi4_m.wready & axi4_m.wvalid;
  assign wr_fifo_if.wdata   = axi4_s.wdata                 ;
  assign axi4_s.wready      = ~wr_fifo_if.w_wr_full        ;
  assign axi4_m.wvalid      = ~wr_fifo_if.w_rd_empty       ;
  assign axi4_m.wdata       =  wr_fifo_if._wdata           ;

  tiny_sync_fifo #(W_W) w_fifo
  ( .wr_full (wr_fifo_if.w_wr_full )
  , .wr_en   (wr_fifo_if.w_wr_en   )
  , .rd_empty(wr_fifo_if.w_rd_empty)
  , .rd_en   (wr_fifo_if.w_rd_en   )
  , .wr_data (wr_fifo_if.w_flat_in )
  , .rd_data (wr_fifo_if.w_flat_out)
  , .*
  );

  // ---------------------------------------------------------------------------
  assign wr_fifo_if.b_wr_en = axi4_m.bready & axi4_m.bvalid;
  assign wr_fifo_if.b_rd_en = axi4_s.bready & axi4_s.bvalid;
  assign wr_fifo_if.wdata   = axi4_m.wdata                 ;
  assign wr_fifo_if.wstrb   = axi4_m.wstrb                 ;
  assign axi4_m.bready      = ~wr_fifo_if.b_wr_full        ;
  assign axi4_s.bvalid      = ~wr_fifo_if.b_rd_empty       ;
  assign axi4_s.wdata       =  wr_fifo_if._wdata           ;
  assign axi4_s.wstrb       =  wr_fifo_if._wstrb           ;

  tiny_sync_fifo #(B_W) b_fifo
  ( .wr_full (wr_fifo_if.b_wr_full  )
  , .wr_en   (wr_fifo_if.b_wr_en    )
  , .rd_empty(wr_fifo_if.b_rd_empty )
  , .rd_en   (wr_fifo_if.b_rd_en    )
  , .wr_data (wr_fifo_if.b_flat_in  )
  , .rd_data (wr_fifo_if.b_flat_out )
  , .*
  );

  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  axi4_bus_rd_fifo_if #(C) rd_fifo_if(.*);

  // ---------------------------------------------------------------------------
  assign rd_fifo_if.ar_wr_en = axi4_s.arready & axi4_s.arvalid;
  assign rd_fifo_if.ar_rd_en = axi4_m.arready & axi4_m.arvalid;
  assign rd_fifo_if.araddr   = axi4_s.araddr                  ;
  assign axi4_s.arready      = ~rd_fifo_if.ar_wr_full         ;
  assign axi4_m.arvalid      = ~rd_fifo_if.ar_rd_empty        ;
  assign axi4_m.araddr       =  rd_fifo_if._araddr            ;

  tiny_sync_fifo #(AR_W) ar_fifo
  ( .wr_full (rd_fifo_if.ar_wr_full  )
  , .wr_en   (rd_fifo_if.ar_wr_en    )
  , .rd_empty(rd_fifo_if.ar_rd_empty )
  , .rd_en   (rd_fifo_if.ar_rd_en    )
  , .wr_data (rd_fifo_if.ar_flat_in  )
  , .rd_data (rd_fifo_if.ar_flat_out )
  , .*
  );

  // ---------------------------------------------------------------------------
  assign rd_fifo_if.r_wr_en = axi4_m.rready & axi4_m.rvalid;
  assign rd_fifo_if.r_rd_en = axi4_s.rready & axi4_s.rvalid;
  assign rd_fifo_if.rdata   = axi4_m.rdata                 ;
  assign rd_fifo_if.rresp   = axi4_m.rresp                 ;
  assign axi4_m.rready      = ~rd_fifo_if.r_wr_full        ;
  assign axi4_s.rvalid      = ~rd_fifo_if.r_rd_empty       ;
  assign axi4_s.rdata       = rd_fifo_if._rdata            ;
  assign axi4_s.rresp       = rd_fifo_if._rresp            ;

  tiny_sync_fifo #(R_W) r_fifo
  ( .wr_full (rd_fifo_if.r_wr_full  )
  , .wr_en   (rd_fifo_if.r_wr_en    )
  , .rd_empty(rd_fifo_if.r_rd_empty )
  , .rd_en   (rd_fifo_if.r_rd_en    )
  , .wr_data (rd_fifo_if.r_flat_in  )
  , .rd_data (rd_fifo_if.r_flat_out )
  , .*
  );

// -----------------------------------------------------------------------------
endmodule

