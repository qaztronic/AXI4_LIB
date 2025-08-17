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

module axi4_lite_bus_sunder_wr #(axi4_lite_pkg::axi4_lite_cfg_t C, int M=0)
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_lite_if axi4_m[2]
);
  // ---------------------------------------------------------------------------
  axi4_bus_wr_fifo_if s_wr_fifo(.*);
  axi4_bus_wr_fifos axi4_bus_wr_fifos_i(.wr_fifo(s_wr_fifo), .*);

  // ---------------------------------------------------------------------------
  localparam D = 4;
  reg [$clog2(D)-1:0] count;
  reg [$clog2(D)-1:0] next_count;
  wire response_done = (count == 0);
  // wire full = &count;

  always_comb
    case({s_wr_fifo.aw_rd_en, s_wr_fifo.b_wr_en})
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
  axi4_bus_wr_fifo_if m_wr_fifo[2](.*);

  generate
    for(genvar j = 0; j < 2; j++)
    begin: out_fifos
        axi4_m_bus_wr_fifos axi4_m_bus_wr_fifos_i
        ( .axi4_m (axi4_m   [j])
        , .wr_fifo(m_wr_fifo[j])
        , .*
        );
    end
  endgenerate

  // ---------------------------------------------------------------------------
  enum reg [3:0]
  { IDLE    = 4'b0001
  , LO_ADDR = 4'b0010
  , HI_ADDR = 4'b0100
  , FLUSH   = 4'b1000
  } state, next_state;

  // ---------------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      state <= IDLE;
    else
      state <= next_state;

  // ---------------------------------------------------------------------------
  wire addr_lo = axi4_s.awaddr < C.A'(M);

  always_comb
    case(state)
      IDLE        : if(~s_wr_fifo.aw_rd_empty)
                      if(addr_lo)
                        next_state = LO_ADDR;
                      else
                        next_state = HI_ADDR;
                    else
                      next_state = IDLE;

      LO_ADDR     : if(s_wr_fifo.aw_rd_empty)
                      if(response_done)
                        next_state = IDLE;
                      else
                        next_state = FLUSH;
                    else
                      if(addr_lo)
                        next_state = LO_ADDR;
                      else
                        if(response_done)
                          next_state = HI_ADDR;
                        else
                          next_state = FLUSH;

      HI_ADDR   : if(s_wr_fifo.aw_rd_empty)
                    if(response_done)
                      next_state = IDLE;
                    else
                      next_state = FLUSH;
                  else
                    if(addr_lo)
                      if(response_done)
                        next_state = LO_ADDR;
                      else
                        next_state = FLUSH;
                    else
                      next_state = HI_ADDR;

      FLUSH   : if(response_done)
                  if(s_wr_fifo.aw_rd_empty)
                    next_state = IDLE;
                  else
                    if(addr_lo)
                      next_state = LO_ADDR;
                    else
                      next_state = HI_ADDR;
                else
                  next_state = FLUSH;

      default : next_state = IDLE;
    endcase

  // ---------------------------------------------------------------------------
  wire route_lo = (next_state == LO_ADDR);
  wire route_hi = (next_state == HI_ADDR);

  // ---------------------------------------------------------------------------
  assign axi4_m[0].awaddr  = axi4_s.awaddr;
  assign axi4_m[1].awaddr  = axi4_s.awaddr;
  assign axi4_m[0].wdata   = axi4_s.wdata;
  assign axi4_m[1].wdata   = axi4_s.wdata;
  assign axi4_s.bresp      = route_lo ? axi4_m[0].bresp : axi4_m[1].bresp;

  // ---------------------------------------------------------------------------
  assign m_wr_fifo[0].aw_wr_en = route_lo & ~m_wr_fifo[0].aw_wr_full & ~s_wr_fifo.w_rd_empty & ~m_wr_fifo[0].w_wr_full;
  assign m_wr_fifo[0].w_wr_en  = m_wr_fifo[0].aw_wr_en;
  assign m_wr_fifo[0].b_rd_en  = ~s_wr_fifo.b_wr_full & ~m_wr_fifo[0].b_rd_empty;

  // ---------------------------------------------------------------------------
  assign m_wr_fifo[1].aw_wr_en = route_hi & ~m_wr_fifo[1].aw_wr_full & ~s_wr_fifo.w_rd_empty & ~m_wr_fifo[1].w_wr_full;
  assign m_wr_fifo[1].w_wr_en  = m_wr_fifo[1].aw_wr_en;
  assign m_wr_fifo[1].b_rd_en  = ~s_wr_fifo.b_wr_full & ~m_wr_fifo[1].b_rd_empty;

  // ---------------------------------------------------------------------------
  assign s_wr_fifo.aw_rd_en = m_wr_fifo[0].aw_wr_en | m_wr_fifo[1].aw_wr_en;
  assign s_wr_fifo.w_rd_en  = m_wr_fifo[0].w_wr_en  | m_wr_fifo[1].w_wr_en ;
  assign s_wr_fifo.b_wr_en  = m_wr_fifo[0].b_rd_en  | m_wr_fifo[1].b_rd_en ;

// -----------------------------------------------------------------------------
endmodule
