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

import axi4_lite_pkg::*;

module axi4_lite_bus_sunder_rd #(axi4_lite_cfg_t C, int M=0)
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_lite_if axi4_m[2]
);
  // --------------------------------------------------------------------
  axi4_bus_rd_fifo_if rd_fifo(.*);
  axi4_s_bus_rd_fifos axi4_bus_rd_fifos_i(.*);

  // --------------------------------------------------------------------
  localparam D = 4;
  reg [$clog2(D)-1:0] count;
  reg [$clog2(D)-1:0] next_count;
  wire response_done = (count == 0);
  wire full = &count;

  always_comb
    case({rd_fifo.ar_rd_en, rd_fifo.r_wr_en})
      'b1_0:   next_count = count + 1;
      'b0_1:   next_count = count - 1;
      default: next_count = count;
    endcase

  always_ff @(posedge aclk)
    if(~aresetn)
      count <= 0;
    else
      count <= next_count;

  // // --------------------------------------------------------------------
  // wire ard_fifo.r_wr_full[2];
  // wire r_rd_empty[2];
  // wire ard_fifo.r_wr_en  [2];
  // wire r_rd_en   [2];

  // axi4_if #(.A(A), .N(N), .I(I))
    // axi4_out_fifo[2](.*);

  // generate
  // begin: out_fifo
    // for(genvar j = 0; j < 2; j++)
      // axi4_m_to_read_fifos #(A, N, I)
        // axi4_m_to_read_fifos_i
        // ( .axi4_m        (axi4_m       [j])
        // , .axi4_read_fifo(axi4_out_fifo[j])
        // , .ard_fifo.r_wr_full    (ard_fifo.r_wr_full   [j])
        // , .ard_fifo.r_wr_en      (ard_fifo.r_wr_en     [j])
        // , .r_rd_empty    (r_rd_empty   [j])
        // , .r_rd_en       (r_rd_en      [j])
        // , .*
        // );
  // end
  // endgenerate

  // --------------------------------------------------------------------
  wire ard_fifo.r_wr_full[2];
  wire r_rd_empty[2];
  wire ard_fifo.r_wr_en  [2];
  wire r_rd_en   [2];

  axi4_if #(.A(A), .N(N), .I(I))
    axi4_out_fifo[2](.*);

  generate
  begin: out_fifo
    for(genvar j = 0; j < 2; j++)
    
    
    
      axi4_m_to_read_fifos #(A, N, I)
        axi4_m_to_read_fifos_i
        ( .axi4_m        (axi4_m       [j])
        , .axi4_read_fifo(axi4_out_fifo[j])
        , .ard_fifo.r_wr_full    (ard_fifo.r_wr_full   [j])
        , .ard_fifo.r_wr_en      (ard_fifo.r_wr_en     [j])
        , .r_rd_empty    (r_rd_empty   [j])
        , .r_rd_en       (r_rd_en      [j])
        , .*
        );
        
  end
  endgenerate

  // // --------------------------------------------------------------------
  // enum reg [1:0]
  // { LO_ADDR = 2'b01
  // , HI_ADDR = 2'b10
  // } state, next_state;

  // // --------------------------------------------------------------------
  // always_ff @(posedge aclk)
    // if(~aresetn)
      // state <= LO_ADDR;
    // else
      // state <= next_state;

  // // --------------------------------------------------------------------
  // wire addr_is_lo = (axi4_in_fifo.araddr < M);

  // always_comb
    // case(state)
      // LO_ADDR:  if(~addr_is_lo & ~rd_fifo.ar_rd_empty & response_done)
                  // next_state = HI_ADDR;
                // else
                  // next_state = LO_ADDR;

      // HI_ADDR:  if(addr_is_lo & ~rd_fifo.ar_rd_empty & response_done)
                  // next_state = LO_ADDR;
                // else
                  // next_state = HI_ADDR;

      // default:  next_state = LO_ADDR;
    // endcase

  // // --------------------------------------------------------------------
  // wire route_lo = ((state == LO_ADDR) & (next_state == LO_ADDR)) | (next_state == LO_ADDR);
  // wire route_hi = ((state == HI_ADDR) & (next_state == HI_ADDR)) | (next_state == HI_ADDR);

  // // --------------------------------------------------------------------
  // assign axi4_out_fifo[0].araddr = axi4_in_fifo.araddr;
  // assign axi4_out_fifo[1].araddr = axi4_in_fifo.araddr;
  // assign axi4_in_fifo.rdata = route_lo ? axi4_out_fifo[0].rdata : axi4_out_fifo[1].rdata;
  // assign axi4_in_fifo.rresp = route_lo ? axi4_out_fifo[0].rresp : axi4_out_fifo[1].rresp;

  // // --------------------------------------------------------------------
  // assign ard_fifo.r_wr_en[0] = route_lo & ~full & ~rd_fifo.ar_rd_empty & ~ard_fifo.r_wr_full[0];
  // assign r_rd_en [0] = route_lo & ~full & ~rd_fifo.r_wr_full   & ~r_rd_empty[0];

  // // --------------------------------------------------------------------
  // assign ard_fifo.r_wr_en[1] = route_hi & ~full & ~rd_fifo.ar_rd_empty & ~ard_fifo.r_wr_full[1];
  // assign r_rd_en [1] = route_hi & ~full & ~rd_fifo.r_wr_full   & ~r_rd_empty[1];

  // // --------------------------------------------------------------------
  // assign rd_fifo.ar_rd_en = ard_fifo.r_wr_en[0] | ard_fifo.r_wr_en[1];
  // assign rd_fifo.r_wr_en  = r_rd_en [0] | r_rd_en [1];

// --------------------------------------------------------------------
endmodule
