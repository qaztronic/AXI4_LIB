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

interface axi4_bus_rd_fifo_if #(axi4_lite_pkg::axi4_lite_cfg_t C='{default: 0})
/* verilator lint_off UNUSEDSIGNAL */
( input aclk
, input aresetn
);
/* verilator lint_on UNUSEDSIGNAL */
  // --------------------------------------------------------------------
  wire ar_rd_en;
  wire ar_rd_empty;
  wire ar_wr_en;
  wire ar_wr_full;

  // --------------------------------------------------------------------
  wire r_wr_full ;
  wire r_wr_en   ;
  wire r_rd_empty;
  wire r_rd_en   ;

  // --------------------------------------------------------------------
  `include "axi4_lite_types.svh"

  // --------------------------------------------------------------------
  wire [ C.A-1:0] araddr;
  wire [AR_W-1:0] ar_flat_in;
  assign ar_flat_in = araddr;

  wire [AR_W-1:0] ar_flat_out;
  /* verilator lint_off UNUSEDSIGNAL */
  wire [ C.A-1:0] _araddr = ar_flat_out;
  /* verilator lint_on UNUSEDSIGNAL */

  // --------------------------------------------------------------------
  /* verilator lint_off UNUSEDSIGNAL */
  /* verilator lint_off UNDRIVEN */
  wire [(8*C.N)-1:0] rdata;
  wire [        1:0] rresp;
  /* verilator lint_on UNUSEDSIGNAL */
  /* verilator lint_on UNDRIVEN */
  axi4_lite_r_t r;
  wire [R_W-1:0] r_flat_in;
  assign r_flat_in = r;

  wire [R_W-1:0] r_flat_out;
  axi4_lite_r_t _r;
  assign _r = r_flat_out;
  wire [(8*C.N)-1:0] _rdata = _r.data;
  wire [        1:0] _rresp = _r.resp;

  // --------------------------------------------------------------------
  modport m
  ( input   araddr
  , output  rdata
  , output  rresp
  , output _araddr
  , input  _rdata
  , input  _rresp
  );

  modport s
  ( output  araddr
  , input   rdata
  , input   rresp
  , input  _araddr
  , output _rdata
  , output _rresp
  );

// --------------------------------------------------------------------
endinterface
