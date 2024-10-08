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

module tiny_sync_fifo #(W=0)
( output  reg       wr_full
, input   [W-1:0]   wr_data
, input             wr_en

, output  reg       rd_empty
, output  [W-1:0]   rd_data
, input             rd_en

, input             clk
, input             reset
);
  // --------------------------------------------------------------------
  wire  writing = wr_en & ~wr_full;
  wire  reading = rd_en & ~rd_empty;

  // --------------------------------------------------------------------
  reg [1:0] rd_ptr_r;
  reg [1:0] next_rd_ptr_r;

  always_comb
    if(reset)
      next_rd_ptr_r = 0;
    else if(reading)
      next_rd_ptr_r = rd_ptr_r + 1;
    else
      next_rd_ptr_r = rd_ptr_r;

  always_ff @(posedge clk)
    rd_ptr_r <= next_rd_ptr_r;

  // --------------------------------------------------------------------
  reg [1:0] wr_ptr_r;
  reg [1:0] next_wr_ptr_r;

  always_comb
    if(reset)
      next_wr_ptr_r = 0;
    else if(writing)
      next_wr_ptr_r = wr_ptr_r + 1;
    else
      next_wr_ptr_r = wr_ptr_r;

  always_ff @(posedge clk)
    wr_ptr_r <= next_wr_ptr_r;

  // --------------------------------------------------------------------
  wire empty_w = (next_wr_ptr_r == next_rd_ptr_r);

  always_ff @(posedge clk)
    if(reset)
      rd_empty <= 1;
    else
      rd_empty <= empty_w;

  // --------------------------------------------------------------------
  wire full_w = ({~next_wr_ptr_r[1],next_wr_ptr_r[0]} == next_rd_ptr_r);

  always_ff @(posedge clk)
    if(reset)
      wr_full <= 0;
    else
      wr_full <= full_w;

  // --------------------------------------------------------------------
  reg   [W-1:0] data_0_r;
  reg   [W-1:0] data_1_r;
  wire  [W-1:0] wr_data_mux = rd_ptr_r[0] ? data_1_r : data_0_r;
  assign rd_data = wr_data_mux;

  always_ff @(posedge clk)
    if(writing)
      if(wr_ptr_r[0])
        data_1_r <= wr_data;
      else
        data_0_r <= wr_data;

// --------------------------------------------------------------------
// synthesis translate_off
  always_ff @(posedge clk)
    if(wr_en & wr_full)
      $stop;
  always_ff @(posedge clk)
    if(rd_en & rd_empty)
      $stop;
// synthesis translate_on
// --------------------------------------------------------------------

// --------------------------------------------------------------------
endmodule
