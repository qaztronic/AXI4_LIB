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
  axis_gear_box
  #(  IN_W = 16 // width in bits
  ,   OUT_W = 14 // width in bits
  ,   ANTECEDENT = 7 // in:out ratio (ANTECEDENT:CONSEQUENT)
  ,   CONSEQUENT = 8
  )
  ( axis_if axis_in
  , axis_if axis_out
  , input   aclk
  , input   aresetn
  );

  // --------------------------------------------------------------------
  localparam B_W = IN_W*ANTECEDENT;
  localparam UB_W = $clog2(B_W);
  localparam UB_A = $clog2(ANTECEDENT);
  localparam UB_C = $clog2(CONSEQUENT);

// --------------------------------------------------------------------
// synthesis translate_off
  initial
  begin
    a_consequent: assert(B_W % CONSEQUENT == 0) else $fatal;
    a_in_w: assert(B_W % IN_W == 0) else $fatal;
    a_out_w: assert(B_W % OUT_W == 0) else $fatal;
  end
// synthesis translate_on
// --------------------------------------------------------------------

  // --------------------------------------------------------------------
  reg [UB_W:0] wr_index;
  reg [UB_A:0] wr_select;
  wire wr_en = axis_in.tvalid & axis_in.tready & aresetn;
  wire wr_end = wr_en & (wr_index == B_W - IN_W);
  wire [UB_W:0] wr_next_index = wr_end ? 0 : wr_index + IN_W;

  always_ff @(posedge aclk)
    if(~aresetn)
      wr_index <= 0;
    else if(wr_en)
      wr_index <= wr_next_index;

  always_ff @(posedge aclk)
    if(~aresetn)
      wr_select <= 0;
    else if(wr_en)
      wr_select <= wr_end ? 0 : wr_select + 1;

  // --------------------------------------------------------------------
  reg [UB_W:0] rd_index;
  reg [UB_C:0] rd_select;
  wire rd_en = axis_out.tvalid & axis_out.tready;
  wire rd_end = rd_en & (rd_index == B_W - OUT_W);
  wire [UB_W:0] rd_next_index = rd_end ? 0 : rd_index + OUT_W;

  always_ff @(posedge aclk)
    if(~aresetn)
      rd_index <= 0;
    else if(rd_en)
      rd_index <= rd_next_index;

  always_ff @(posedge aclk)
    if(~aresetn)
      rd_select <= 0;
    else if(rd_en)
      rd_select <= rd_end ? 0 : rd_select + 1;

  // --------------------------------------------------------------------
  reg [B_W:0] buffer;
  genvar j;

  generate
  begin: buffer_gen
    for(j = 0; j < B_W/IN_W; j++)
      always_ff @(posedge aclk)
        if(wr_en & (wr_select == j))
          buffer[j*IN_W +: IN_W] <= axis_in.tdata[IN_W-1:0];
  end
  endgenerate

  // --------------------------------------------------------------------
  localparam MC_DO = 2**$clog2(CONSEQUENT); // max count
  wire [OUT_W-1:0] data_in[MC_DO-1:0];
  wire [OUT_W-1:0] data_out;

  generate
  begin: data_out_gen
    for(j = 0; j < CONSEQUENT; j++)
      assign data_in[j] = buffer[j*OUT_W +: OUT_W];
    if(MC_DO > CONSEQUENT)
      for(j = CONSEQUENT; j < MC_DO; j++)
        assign data_in[j] = 0;
  end
  endgenerate

  // --------------------------------------------------------------------
  recursive_mux #(.A($clog2(CONSEQUENT)), .W(OUT_W))
    recursive_mux_i(.select(rd_select), .*);

  //---------------------------------------------------
  enum reg [1:0]
    { SAME      = 2'b01,
      WR_LAPPED = 2'b10
    } state, next_state;

  //---------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      state <= SAME;
    else
      state <= next_state;

  //---------------------------------------------------
  always_comb
    case(state)
      SAME:       if(wr_end & ~rd_end)
                    next_state <= WR_LAPPED;
                  else
                    next_state <= SAME;

      WR_LAPPED:  if(rd_end & ~wr_end)
                    next_state <= SAME;
                  else
                    next_state <= WR_LAPPED;

      default:    next_state <= SAME;
    endcase

  // --------------------------------------------------------------------
  wire empty = (state == SAME) ? rd_next_index > wr_index : 0;
  wire full = (state == SAME) ? 0 : wr_next_index > rd_index;
  assign axis_in.tready = ~full;
  assign axis_out.tvalid = ~empty;
  assign axis_out.tdata = data_out;

// --------------------------------------------------------------------
endmodule
