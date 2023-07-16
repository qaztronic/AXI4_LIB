// --------------------------------------------------------------------
// Copyright 2020 qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License");
// you may not use this file except in compliance with the License, or,
// at your option, the Apache License version 2.0. You may obtain a copy
// of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.
// --------------------------------------------------------------------

module axi4_lite_cdc #(A, N, I=1)
( axi4_if axi4_m
, axi4_if axi4_s
, input   m_aclk
, input   m_aresetn
, input   s_aclk
, input   s_aresetn
);
  // --------------------------------------------------------------------
  wire ar_wr_full;
  wire ar_rd_empty;
  assign axi4_s.arready = ~ar_wr_full;
  assign axi4_m.arvalid = ~ar_rd_empty;
  wire ar_wr_en = axi4_s.arready & axi4_s.arvalid;
  wire ar_rd_en = axi4_m.arvalid & axi4_m.arready;

  typedef axi4_m.axi4_lite_ar_s axi4_lite_ar_s;
  wire [$bits(axi4_lite_ar_s)-1:0] ar_flat;
  axi4_lite_ar_s ar;
  assign ar = ar_flat;

  assign axi4_m.araddr = ar.addr;

  async_fifo #($bits(axi4_lite_ar_s), 16)
    fifo_ar
    ( .wr_full (ar_wr_full    )
    , .wr_data (axi4_s.ar_flat)
    , .wr_en   (ar_wr_en      )
    , .wr_clk  (s_aclk        )
    , .wr_reset(~s_aresetn    )
    , .rd_empty(ar_rd_empty   )
    , .rd_data (ar_flat       )
    , .rd_en   (ar_rd_en      )
    , .rd_clk  (m_aclk        )
    , .rd_reset(~m_aresetn    )
    );

  // --------------------------------------------------------------------
  wire aw_wr_full;
  wire aw_rd_empty;
  assign axi4_s.awready = ~aw_wr_full;
  assign axi4_m.awvalid = ~aw_rd_empty;
  wire aw_wr_en = axi4_s.awready & axi4_s.awvalid;
  wire aw_rd_en = axi4_m.awvalid & axi4_m.awready;

  typedef axi4_m.axi4_lite_aw_s axi4_lite_aw_s;
  wire [$bits(axi4_lite_aw_s)-1:0] aw_flat;
  axi4_lite_aw_s aw;
  assign aw = aw_flat;

  assign axi4_m.awaddr = aw.addr;

  async_fifo #($bits(axi4_lite_aw_s), 16)
    fifo_aw
    ( .wr_full (aw_wr_full    )
    , .wr_data (axi4_s.aw_flat)
    , .wr_en   (aw_wr_en      )
    , .wr_clk  (s_aclk        )
    , .wr_reset(~s_aresetn    )
    , .rd_empty(aw_rd_empty   )
    , .rd_data (aw_flat       )
    , .rd_en   (aw_rd_en      )
    , .rd_clk  (m_aclk        )
    , .rd_reset(~m_aresetn    )
    );

  // --------------------------------------------------------------------
  wire w_wr_full;
  wire w_rd_empty;
  assign axi4_s.wready = ~w_wr_full;
  assign axi4_m.wvalid = ~w_rd_empty;
  wire w_wr_en = axi4_s.wready & axi4_s.wvalid;
  wire w_rd_en = axi4_m.wvalid & axi4_m.wready;

  typedef axi4_m.axi4_lite_w_s axi4_lite_w_s;
  wire [$bits(axi4_lite_w_s)-1:0] w_flat;
  axi4_lite_w_s w;
  assign w = w_flat;

  assign axi4_m.wdata = w.data;
  assign axi4_m.wstrb = w.strb;

  async_fifo #($bits(axi4_lite_w_s), 16)
    fifo_w
    ( .wr_full (w_wr_full    )
    , .wr_data (axi4_s.w_flat)
    , .wr_en   (w_wr_en      )
    , .wr_clk  (s_aclk       )
    , .wr_reset(~s_aresetn   )
    , .rd_empty(w_rd_empty   )
    , .rd_data (w_flat       )
    , .rd_en   (w_rd_en      )
    , .rd_clk  (m_aclk       )
    , .rd_reset(~m_aresetn   )
    );

  // --------------------------------------------------------------------
  wire b_wr_full;
  wire b_rd_empty;
  assign axi4_m.bready = ~b_wr_full;
  assign axi4_s.bvalid = ~b_rd_empty;
  wire b_wr_en = axi4_m.bready & axi4_m.bvalid;
  wire b_rd_en = axi4_s.bvalid & axi4_s.bready;

  typedef axi4_s.axi4_lite_b_s axi4_lite_b_s;
  wire [$bits(axi4_lite_b_s)-1:0] b_flat;
  axi4_lite_b_s b;
  assign b = b_flat;

  assign axi4_s.bresp = b.resp;

  async_fifo #($bits(axi4_lite_b_s), 16)
    fifo_b
    ( .wr_full (b_wr_full    )
    , .wr_data (axi4_m.b_flat)
    , .wr_en   (b_wr_en      )
    , .wr_clk  (m_aclk       )
    , .wr_reset(~m_aresetn   )
    , .rd_empty(b_rd_empty   )
    , .rd_data (b_flat       )
    , .rd_en   (b_rd_en      )
    , .rd_clk  (s_aclk       )
    , .rd_reset(~s_aresetn   )
    );

  // --------------------------------------------------------------------
  wire r_wr_full;
  wire r_rd_empty;
  assign axi4_m.rready = ~r_wr_full;
  assign axi4_s.rvalid = ~r_rd_empty;
  wire r_wr_en = axi4_m.rready & axi4_m.rvalid;
  wire r_rd_en = axi4_s.rvalid & axi4_s.rready;

  typedef axi4_s.axi4_lite_r_s axi4_lite_r_s;
  wire [$bits(axi4_lite_r_s)-1:0]r_flat;
  axi4_lite_r_s r;
  assign r = r_flat;

  assign axi4_s.rdata = r.data;
  assign axi4_s.rresp = r.resp;

  async_fifo #($bits(axi4_lite_r_s), 16)
    fifo_r
    ( .wr_full (r_wr_full    )
    , .wr_data (axi4_m.r_flat)
    , .wr_en   (r_wr_en      )
    , .wr_clk  (m_aclk       )
    , .wr_reset(~m_aresetn   )
    , .rd_empty(r_rd_empty   )
    , .rd_data (r_flat       )
    , .rd_en   (r_rd_en      )
    , .rd_clk  (s_aclk       )
    , .rd_reset(~s_aresetn   )
    );

// --------------------------------------------------------------------
endmodule
