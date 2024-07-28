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

module axi4_lite_default_slave #(A=0, N=0, I=1, D='hbaadc0de)
( axi4_if axi4_s
, input   aclk
, input   aresetn
);
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  enum reg [1:0]
  { IDLE    = 2'b01
  , VALID   = 2'b10
  } w_state, w_next_state, r_state, r_next_state;

  //---------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      w_state <= IDLE;
    else
      w_state <= w_next_state;

  //---------------------------------------------------
  always_comb
    case(w_state)
      IDLE:     if(axi4_s.awvalid & axi4_s.wvalid)
                  w_next_state = VALID;
                else
                  w_next_state = IDLE;

      VALID:  if(axi4_s.bready)
                  w_next_state = IDLE;
                else
                  w_next_state = VALID;

      default:  w_next_state = IDLE;
    endcase

  //---------------------------------------------------
  assign axi4_s.awready = (w_state == IDLE) & axi4_s.awvalid & axi4_s.wvalid;
  assign axi4_s.wready  = axi4_s.awvalid & axi4_s.wvalid;
  assign axi4_s.bvalid  = (w_state == VALID);
  assign axi4_s.bresp   = 2'b11;

  //---------------------------------------------------
  reg [I-1:0] bid_r;
  assign axi4_s.bid = bid_r;

  always_ff @(posedge aclk)
    if(axi4_s.awvalid)
      bid_r <= axi4_s.awid;

  //---------------------------------------------------
  //---------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      r_state <= IDLE;
    else
      r_state <= r_next_state;

  //---------------------------------------------------
  always_comb
    case(r_state)
      IDLE:     if(axi4_s.arvalid)
                  r_next_state = VALID;
                else
                  r_next_state = IDLE;

      VALID:    if(axi4_s.rready)
                  r_next_state = IDLE;
                else
                  r_next_state = VALID;

      default:  r_next_state = IDLE;
    endcase

  // --------------------------------------------------------------------
  assign axi4_s.arready = (r_state == IDLE) & axi4_s.arvalid;
  assign axi4_s.rvalid = (r_state == VALID);
  assign axi4_s.rdata  = D;
  assign axi4_s.rresp  = 2'b11;
  assign axi4_s.rlast  = 1;

  //---------------------------------------------------
  reg [I-1:0] rid_r;
  assign axi4_s.rid = rid_r;

  always_ff @(posedge aclk)
    if(axi4_s.arvalid)
      rid_r <= axi4_s.arid;

// --------------------------------------------------------------------
endmodule
