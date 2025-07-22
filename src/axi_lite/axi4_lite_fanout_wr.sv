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

module axi4_lite_fanout_wr
#( int         A=0
,  int         N=0
,  bit [A-1:0] M=0
,  int         I=1
,  int         D=4
)
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_lite_if axi4_m[2]
);
  // --------------------------------------------------------------------
  wire aw_rd_empty;
  wire w_rd_empty;
  wire b_wr_full;
  wire aw_rd_en;
  wire w_rd_en ;
  wire b_wr_en ;

  axi4_if #(.A(A), .N(N), .I(I))
    axi4_in_fifo(.*);

  axi4_s_to_write_fifos #(.A(A), .N(N), .I(I), .USE_ADVANCED_PROTOCOL(0))
    axi4_s_to_write_fifos_i(.axi4_write_fifo(axi4_in_fifo), .*);

  // --------------------------------------------------------------------
  reg [$clog2(D)-1:0] count;
  reg [$clog2(D)-1:0] next_count;
  wire response_done = (count == 0);
  wire full = &count;

  always_comb
    case({aw_rd_en, b_wr_en})
      'b1_0:   next_count = count + 1;
      'b0_1:   next_count = count - 1;
      default: next_count = count;
    endcase

  always_ff @(posedge aclk)
    if(~aresetn)
      count <= 0;
    else
      count <= next_count;

  // --------------------------------------------------------------------
  wire aw_wr_full[2];
  wire w_wr_full [2];
  wire b_rd_empty[2];
  wire aw_wr_en  [2];
  wire w_wr_en   [2];
  wire b_rd_en   [2];

  axi4_if #(.A(A), .N(N), .I(I))
    axi4_out_fifo[2](.*);

  generate
  begin: out_fifo
    for(genvar j = 0; j < 2; j++)
      axi4_m_to_write_fifos #(A, N, I)
        axi4_m_to_write_fifos_i
        ( .axi4_m         (axi4_m       [j])
        , .axi4_write_fifo(axi4_out_fifo[j])
        , .aw_wr_full     (aw_wr_full   [j])
        , .aw_wr_en       (aw_wr_en     [j])
        , .w_wr_full      (w_wr_full    [j])
        , .w_wr_en        (w_wr_en      [j])
        , .b_rd_empty     (b_rd_empty   [j])
        , .b_rd_en        (b_rd_en      [j])
        , .*
        );
  end
  endgenerate

  // --------------------------------------------------------------------
  enum reg [3:0]
  { IDLE    = 4'b0001
  , LO_ADDR = 4'b0010
  , HI_ADDR = 4'b0100
  , FLUSH   = 4'b1000
  } state, next_state;

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      state <= IDLE;
    else
      state <= next_state;

  // --------------------------------------------------------------------
  wire addr_lo = axi4_in_fifo.awaddr < M;

  always_comb
    case(state)
      IDLE        : if(~aw_rd_empty)
                      if(addr_lo)
                        next_state = LO_ADDR;
                      else
                        next_state = HI_ADDR;
                    else
                      next_state = IDLE;

      LO_ADDR     : if(aw_rd_empty)
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

      HI_ADDR   : if(aw_rd_empty)
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
                  if(aw_rd_empty)
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

  // --------------------------------------------------------------------
  wire route_lo = (next_state == LO_ADDR);
  wire route_hi = (next_state == HI_ADDR);

  // --------------------------------------------------------------------
  assign axi4_out_fifo[0].awaddr  = axi4_in_fifo.awaddr;
  assign axi4_out_fifo[1].awaddr  = axi4_in_fifo.awaddr;
  assign axi4_out_fifo[0].wdata   = axi4_in_fifo.wdata;
  assign axi4_out_fifo[1].wdata   = axi4_in_fifo.wdata;
  assign axi4_in_fifo.bresp       = route_lo ? axi4_out_fifo[0].bresp : axi4_out_fifo[1].bresp;

  // --------------------------------------------------------------------
  assign aw_wr_en[0] = route_lo & ~aw_wr_full[0] & ~w_rd_empty & ~w_wr_full [0];
  assign w_wr_en [0] = aw_wr_en[0];
  assign b_rd_en [0] = ~b_wr_full & ~b_rd_empty[0];

  // --------------------------------------------------------------------
  assign aw_wr_en[1] = route_hi & ~aw_wr_full[1] & ~w_rd_empty & ~w_wr_full [1];
  assign w_wr_en [1] = aw_wr_en[1];
  assign b_rd_en [1] = ~b_wr_full & ~b_rd_empty[1];

  // --------------------------------------------------------------------
  assign aw_rd_en = aw_wr_en[0] | aw_wr_en[1];
  assign w_rd_en  = w_wr_en [0] | w_wr_en [1];
  assign b_wr_en  = b_rd_en [0] | b_rd_en [1];

// --------------------------------------------------------------------
endmodule
