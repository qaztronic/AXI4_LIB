// -------------------------------------------------------------------------------
// Copyright qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may
// not use this file except in compliance with the License, or, at your option,
// the Apache License version 2.0. You may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed
// under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
// -------------------------------------------------------------------------------

module asv_enforcer #(W=0, H=0, B=0)
( input      aclk
, input      aresetn
, input      tvalid
, input      tready
, input      sof_in
, input      eol_in
, output reg sof_out
, output reg sol_out
, output reg eol_out
, output reg eof_out
);
  // --------------------------------------------------------------------
  if(B > W)
  begin : E0  $error("!!! | %m | H > W"); end
  reg [$clog2(W):0] pixel_count;
  reg [$clog2(H):0] line_count;

  // --------------------------------------------------------------------
  enum reg [5:0]
  { IDLE    = 6'b00_0001
  , SOF     = 6'b00_0010
  , SOL     = 6'b00_0100
  , PIXELS  = 6'b00_1000
  , H_BLANK = 6'b01_0000
  , EOF     = 6'b10_0000
  } state, next_state;

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      state <= IDLE;
    else
      state <= next_state;

  // --------------------------------------------------------------------
  always_comb
    case(state)
      IDLE    : if(tvalid & tready & sof_in)
                  next_state = SOF;
                else
                  next_state = IDLE;

      SOF     : next_state = PIXELS;

      SOL     : next_state = PIXELS;

      PIXELS  : if(pixel_count >= W-1)
                  if(line_count >= H-1)
                    next_state = EOF;
                  else
                    next_state = H_BLANK;
                else
                  next_state = PIXELS;

      H_BLANK : if(pixel_count >= B-1)
                  next_state = SOL;
                else
                  next_state = H_BLANK;

      EOF     : next_state = IDLE;

      default : next_state = IDLE;
    endcase

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn | (state != next_state))
      pixel_count <= 0;
    else if(tvalid & tready)
      pixel_count <= pixel_count + 1;

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn | sof_in)
      line_count <= 0;
    else if(tvalid & tready & eol_in)
      line_count <= line_count + 1;

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    sof_out <= sof_in;

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    sol_out <= (next_state == SOF) | (next_state == SOL);

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    eol_out <= eol_in;

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    eof_out <= (next_state == EOF);

// --------------------------------------------------------------------
endmodule
