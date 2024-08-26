// --------------------------------------------------------------------
// Copyright 2024 qaztronic
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

module cdc_pulse_sync
( input      a_clk
, input      a_reset
, input      a_pulse_in
, output     a_busy
, output reg a_error
, input      b_clk
, input      b_reset
, output     b_pulse_out
, output reg b_error
);
  // --------------------------------------------------------------------
  wire a_ack;
  wire b_ack;

  cdc_sync ack_i
  ( .in_clk (b_clk)
  , .in     (b_ack)
  , .out_clk(a_clk)
  , .out    (a_ack)
  );

  // --------------------------------------------------------------------
  enum reg [3:0]
  { IDLE  = 4'b0001
  , ACK   = 4'b0010
  , PULSE = 4'b0100
  , ERROR = 4'b1000
  } a_state, a_next_state, b_state, b_next_state;

  // --------------------------------------------------------------------
  always_ff @(posedge a_clk)
  if(a_reset)
    a_state <= IDLE;
  else
    a_state <= a_next_state;

  // --------------------------------------------------------------------
  always_comb
    case(a_state)
    IDLE    : if(a_pulse_in)
                a_next_state <= ACK;
              else
                a_next_state <= IDLE;

    ACK     : if(a_ack)
                a_next_state <= IDLE;
              else
                a_next_state <= ACK;

    PULSE   : a_next_state <= ERROR;

    ERROR   : a_next_state <= IDLE;

    default : a_next_state <= ERROR;
  endcase

  // --------------------------------------------------------------------
  assign a_busy = (a_state != IDLE);

  always_ff @(posedge a_clk)
    if(a_reset)
      a_error <= 0;
    else if((a_state == ERROR) | (a_pulse_in & a_busy))
      a_error <= 1;

  // --------------------------------------------------------------------
  wire a_req = (a_state == ACK);
  wire b_req;

  cdc_sync req_i
  ( .in_clk (a_clk)
  , .in     (a_req)
  , .out_clk(b_clk)
  , .out    (b_req)
  );

  // --------------------------------------------------------------------
  always_ff @(posedge b_clk)
    if(b_reset)
      b_state <= IDLE;
    else
      b_state <= b_next_state;

  // --------------------------------------------------------------------
  always_comb
    case(b_state)
    IDLE    : if(b_req)
                b_next_state <= ACK;
              else
                b_next_state <= IDLE;

    ACK     : if(~b_req)
                b_next_state <= PULSE;
              else
                b_next_state <= ACK;

    PULSE   : b_next_state <= IDLE;

    ERROR   : b_next_state <= IDLE;

    default : b_next_state <= ERROR;
  endcase

  // --------------------------------------------------------------------
  assign b_ack       = (b_state == ACK  );
  assign b_pulse_out = (b_state == PULSE);

  always_ff @(posedge b_clk)
    if(b_reset)
      b_error <= 0;
    else if(b_state == ERROR)
      b_error <= 1;

// --------------------------------------------------------------------
endmodule
