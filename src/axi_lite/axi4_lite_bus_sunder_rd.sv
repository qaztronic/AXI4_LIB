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

module axi4_lite_bus_sunder_rd #(axi4_lite_pkg::axi4_lite_cfg_t C, int M=0)
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_lite_if axi4_m[2]
);
  // ---------------------------------------------------------------------------
  axi4_bus_rd_fifo_if #(C) s_rd_fifo(.*);
  axi4_bus_rd_fifos axi4_bus_rd_fifos_i(.axi4_bus(axi4_s), .rd_fifo(s_rd_fifo), .*);

  // ---------------------------------------------------------------------------
  localparam D = 4;
  reg [$clog2(D)-1:0] count;
  reg [$clog2(D)-1:0] next_count;
  wire response_done = (count == 0);
  wire ready = ~(&count);

  always_comb
    case({s_rd_fifo.ar_rd_en, s_rd_fifo.r_wr_en})
      'b1_0:   next_count = count + 1;
      'b0_1:   next_count = count - 1;
      default: next_count = count;
    endcase

  always_ff @(posedge aclk)
    if(~aresetn)
      count <= 0;
    else
      count <= next_count;

  // ---------------------------------------------------------------------------
  axi4_bus_rd_fifo_if #(C) m_rd_fifo[2](.*);
  // axi4_bus_wr_fifo_if #(C) m_wr_fifo[2](.*);
  // assign m_wr_fifo[0].aw_wr_en = 0;
  // assign m_wr_fifo[1].aw_wr_en = 0;
  // assign m_wr_fifo[0].aw_rd_en = 0;
  // assign m_wr_fifo[1].aw_rd_en = 0;
  // assign m_wr_fifo[0].b_wr_en = 0;
  // assign m_wr_fifo[1].b_wr_en = 0;

  generate
    for(genvar j = 0; j < 2; j++)
    begin: out_fifos
        axi4_bus_rd_fifos axi4_bus_rd_fifos_i
        ( .rd_fifo (m_rd_fifo[j])
        , .axi4_bus(axi4_m   [j])
        , .*
        );
    end
  endgenerate

  // ---------------------------------------------------------------------------
  enum reg [1:0]
  { LO_ADDR = 2'b01
  , HI_ADDR = 2'b10
  } state, next_state;

  // ---------------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      state <= LO_ADDR;
    else
      state <= next_state;

  // ---------------------------------------------------------------------------
  wire addr_is_lo = (axi4_s.araddr < C.A'(M));

  always_comb
    case(state)
      LO_ADDR:  if(~addr_is_lo & ~s_rd_fifo.ar_rd_empty & response_done)
                  next_state = HI_ADDR;
                else
                  next_state = LO_ADDR;

      HI_ADDR:  if(addr_is_lo & ~s_rd_fifo.ar_rd_empty & response_done)
                  next_state = LO_ADDR;
                else
                  next_state = HI_ADDR;

      default:  next_state = LO_ADDR;
    endcase

  // ---------------------------------------------------------------------------
  // wire route_lo = ((state == LO_ADDR) & (next_state == LO_ADDR)) | (next_state == LO_ADDR);
  // wire route_hi = ((state == HI_ADDR) & (next_state == HI_ADDR)) | (next_state == HI_ADDR);
  wire route_lo = (next_state == LO_ADDR);
  wire route_hi = (next_state == HI_ADDR);

  // ---------------------------------------------------------------------------
  assign axi4_m[0].araddr = axi4_s.araddr;
  assign axi4_m[1].araddr = axi4_s.araddr;
  assign axi4_s.rdata = route_lo ? axi4_m[0].rdata : axi4_m[1].rdata;
  assign axi4_s.rresp = route_lo ? axi4_m[0].rresp : axi4_m[1].rresp;

  // ---------------------------------------------------------------------------
  // assign m_rd_fifo[0].ar_wr_en = route_lo & ~full & ~s_rd_fifo.ar_rd_empty & ~m_rd_fifo[0].ar_wr_full;
  assign axi4_m[0].arvalid    = route_lo & aresetn & ready & ~s_rd_fifo.ar_rd_empty & ~m_rd_fifo[0].ar_wr_full;
  assign m_rd_fifo[0].r_rd_en = route_lo & aresetn & ready & ~s_rd_fifo.r_wr_full   & ~m_rd_fifo[0].r_rd_empty;

  // ---------------------------------------------------------------------------
  // assign m_rd_fifo[1].ar_wr_en = route_hi & ~full & ~s_rd_fifo.ar_rd_empty & ~m_rd_fifo[1].ar_wr_full;
  assign axi4_m[1].arvalid    = route_hi & aresetn & ready & ~s_rd_fifo.ar_rd_empty & ~m_rd_fifo[1].ar_wr_full;
  assign m_rd_fifo[1].r_rd_en = route_hi & aresetn & ready & ~s_rd_fifo.r_wr_full   & ~m_rd_fifo[1].r_rd_empty;

  // ---------------------------------------------------------------------------
  // assign s_rd_fifo.ar_rd_en = m_rd_fifo[0].ar_wr_en | m_rd_fifo[1].ar_wr_en;
  assign s_rd_fifo.ar_rd_en = axi4_m[0].arvalid | axi4_m[1].arvalid;
  assign s_rd_fifo.r_wr_en  = m_rd_fifo[0].r_rd_en | m_rd_fifo[1].r_rd_en;

// -----------------------------------------------------------------------------
endmodule
