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

/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
interface axi4_bus_wr_fifo_if #(axi4_lite_pkg::axi4_lite_cfg_t C='{default: 0})
( input aclk
, input aresetn
);
  // --------------------------------------------------------------------
  wire aw_rd_en;
  wire aw_rd_empty;
  wire aw_wr_en;
  wire aw_wr_full;

  // --------------------------------------------------------------------
  wire w_wr_full ;
  wire w_wr_en   ;
  wire w_rd_empty;
  wire w_rd_en   ;

  // --------------------------------------------------------------------
  wire b_wr_full ;
  wire b_wr_en   ;
  wire b_rd_empty;
  wire b_rd_en   ;

  // --------------------------------------------------------------------
  `include "axi4_lite_types.svh"

  // --------------------------------------------------------------------
  wire [ C.A-1:0] awaddr ;
  wire [AW_W-1:0] aw_flat_in;
  assign aw_flat_in = awaddr;

  wire [AW_W-1:0] aw_flat_out;
  wire [ C.A-1:0] _awaddr ;
  assign _awaddr = aw_flat_out;

  // --------------------------------------------------------------------
  wire [    1:0] bresp    ;
  wire [B_W-1:0] b_flat_in;
  assign b_flat_in = bresp;

  wire [B_W-1:0] b_flat_out;
  wire [    1:0] _bresp = b_flat_out;

  // --------------------------------------------------------------------
  wire [(8*C.N)-1:0] wdata;
  wire [    C.N-1:0] wstrb;
  wire [    W_W-1:0] w_flat_in;
  wire [(8*C.N)-1:0] _wdata;
  wire [    C.N-1:0] _wstrb;
  wire [    W_W-1:0] w_flat_out;

  generate
  begin : pack_w
    if(C.USE_STRB == 0)
    begin : omit_strb
      // ....................................
      axi4_lite_w_0_t w;
      assign w.data    = wdata;
      assign w_flat_in = w;

      // ....................................
      axi4_lite_w_0_t _w;
      assign _w     = w_flat_out;
      assign _wdata = _w.data;
      assign _wstrb = 0;
    end
    else
    begin : use_strb
      // ....................................
      axi4_lite_w_1_t w;
      assign w.data    = wdata;
      assign w.strb    = wstrb;
      assign w_flat_in = w;

      // ....................................
      axi4_lite_w_0_t _w;
      assign _w     = w_flat_out;
      assign _wdata = _w.data;
      assign _wstrb = _w.strb;
    end
  end
  endgenerate

  // --------------------------------------------------------------------
  modport m
  ( input   awaddr
  , input   wdata
  , output  bresp
  , output _awaddr
  , output _wdata
  , input  _bresp
  );

  modport s
  ( output  awaddr
  , output  wdata
  , input   bresp
  , input  _awaddr
  , input  _wdata
  , output _bresp
  );

/* verilator lint_on UNUSEDSIGNAL */
/* verilator lint_on UNDRIVEN */
// --------------------------------------------------------------------
endinterface
