// --------------------------------------------------------------------
// Copyright 2020 qaztronic
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

module
  axis_fanout #(F)
  ( axis_if axis_in
  , axis_if axis_out[F]
  , input   aclk
  , input   aresetn
  );

  // --------------------------------------------------------------------
  wire [F-1:0] handshake;
  wire [F-1:0] stalled;
  reg [F-1:0] transfer_stalled;
  wire [F-1:0] out_tready;
  wire all_ready = &out_tready;
  wire [F-1:0] done;
  wire all_done = &done;

  // --------------------------------------------------------------------
  enum reg [1:0]
    {
      FANOUT  = 2'b01,
      STALL   = 2'b10
    } state, next_state;

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      state <= FANOUT;
    else
      state <= next_state;

  // --------------------------------------------------------------------
  always_comb
    case(state)
      FANOUT:   if(~axis_in.tvalid)
                  next_state = FANOUT;
                else if(all_ready)
                  next_state = FANOUT;
                else
                  next_state = STALL;

      STALL:    if(all_done)
                  next_state = FANOUT;
                else
                  next_state = STALL;

      default:  next_state = FANOUT;
    endcase

  // --------------------------------------------------------------------
  generate
    for(genvar j = 0; j < F; j++)
    begin: tready_gen
      // --------------------------------------------------------------------
      assign handshake[j] = axis_in.tvalid &  axis_out[j].tready;
      assign stalled[j]   = axis_in.tvalid & ~axis_out[j].tready;
      assign done[j]      = ~transfer_stalled[j] | handshake[j];

      always_ff @(posedge aclk)
        if(handshake[j])
          transfer_stalled[j] <= 0;
        else if(stalled[j])
          transfer_stalled[j] <= 1;

      // --------------------------------------------------------------------
      assign out_tready[j]      = axis_out[j].tready;
      assign axis_out[j].tlast  = axis_in.tlast;
      assign axis_out[j].tuser  = axis_in.tuser;
      assign axis_out[j].tdata  = axis_in.tdata;
      assign axis_out[j].tstrb  = axis_in.tstrb;
      assign axis_out[j].tkeep  = axis_in.tkeep;
      assign axis_out[j].tid    = axis_in.tid;
      assign axis_out[j].tdest  = axis_in.tdest;
      assign axis_out[j].tvalid = (state == FANOUT) ? axis_in.tvalid : transfer_stalled[j];
    end
  endgenerate

  // --------------------------------------------------------------------
  assign axis_in.tready = (state == FANOUT) ? all_ready : (next_state == FANOUT);

// --------------------------------------------------------------------
endmodule
