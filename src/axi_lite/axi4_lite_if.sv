// --------------------------------------------------------------------
// Copyright qaztronic
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

/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
interface axi4_lite_if #(axi4_lite_pkg::axi4_lite_cfg_t C='{default: 0})
( input aclk
, input aresetn
);
import axi4_lite_pkg::*;
  // --------------------------------------------------------------------
  wire [    C.A-1:0] araddr ;
  wire               arready;
  wire               arvalid;
  wire [    C.A-1:0] awaddr ;
  wire               awready;
  wire               awvalid;
  wire               bready ;
  wire [        1:0] bresp  ;
  wire               bvalid ;
  wire [(8*C.N)-1:0] rdata  ;
  wire               rready ;
  wire [        1:0] rresp  ;
  wire               rvalid ;
  wire [(8*C.N)-1:0] wdata  ;
  wire               wready ;
  wire               wvalid ;

  // --------------------------------------------------------------------
  wire [C.N-1:0] wstrb;

  generate
    if(C.USE_STRB == 0)
    begin : strb
      assign wstrb = 0;
    end
  endgenerate

  // --------------------------------------------------------------------
  wire [2:0] arprot;
  wire [2:0] awprot;

  generate
    if(C.USE_PROT == 0)
    begin : prot
      assign arprot = 0;
      assign awprot = 0;
    end
  endgenerate

  // --------------------------------------------------------------------
  /* verilator lint_off ASCRANGE */
  wire [C.I-1:0] arid;
  wire [C.I-1:0] awid;
  wire [C.I-1:0] bid ;
  wire [C.I-1:0] rid ;
  wire [C.I-1:0] wid ;
  /* verilator lint_on ASCRANGE */

  generate
    if(C.I < 1)
    begin : id
      assign arid = 0;
      assign awid = 0;
      assign bid  = 0;
      assign rid  = 0;
      assign wid  = 0;
    end
  endgenerate

  // --------------------------------------------------------------------
  typedef struct packed {
    logic [C.A-1:0] addr;
  } axi4_lite_ar_t;

  localparam AR_W = $bits(axi4_lite_ar_t);

  axi4_lite_ar_t ar;
  assign ar.addr = araddr;
  wire [AR_W-1:0] ar_flat_in;
  assign ar_flat_in = ar;

  wire [AR_W-1:0] ar_flat_out;
  wire [ C.A-1:0] _araddr = ar_flat_out;

  // --------------------------------------------------------------------
  typedef struct packed {
    logic [C.A-1:0] addr;
  } axi4_lite_aw_t;

  localparam AW_W = $bits(axi4_lite_aw_t);

  axi4_lite_aw_t aw;
  wire [AW_W-1:0] aw_flat_in;
  assign aw_flat_in = aw;
  assign aw.addr = awaddr;

  wire [AW_W-1:0] aw_flat_out;
  wire [ C.A-1:0] _awaddr = aw_flat_out;

  // --------------------------------------------------------------------
  typedef struct packed {
    logic [1:0] resp;
  } axi4_lite_b_t;

  localparam B_W = $bits(axi4_lite_b_t);

  axi4_lite_b_t b;
  assign b.resp = bresp;
  wire [B_W-1:0] b_flat_in;
  assign b_flat_in = b;

  wire [B_W-1:0] b_flat_out;
  wire [    1:0] _bresp = b_flat_out;

  // --------------------------------------------------------------------
  typedef struct packed {
    logic [(8*C.N)-1:0] data;
    logic [        1:0] resp;
  } axi4_lite_r_t;

  localparam R_W = $bits(axi4_lite_r_t);

  axi4_lite_r_t r;
  assign r.data = rdata;
  assign r.resp = rresp;
  wire [R_W-1:0] r_flat_in;
  assign r_flat_in = r;

  wire [R_W-1:0] r_flat_out;
  axi4_lite_r_t _r = r_flat_out;
  wire [(8*C.N)-1:0] _rdata = _r.data;
  wire [        1:0] _rresp = _r.resp;

  // --------------------------------------------------------------------
  wire [(8*C.N)-1:0] _wdata;
  wire [    C.N-1:0] _wstrb;

  typedef struct packed {
    logic [(8*C.N)-1:0] data;
  } axi4_lite_w_0_t;

  typedef struct packed {
    logic [(8*C.N)-1:0] data;
    logic [    C.N-1:0] strb;
  } axi4_lite_w_1_t;

  localparam W_W = (C.USE_STRB == 0) ? $bits(axi4_lite_w_0_t) : $bits(axi4_lite_w_1_t);
  wire [W_W-1:0] w_flat_in;
  wire [W_W-1:0] w_flat_out;

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

/* verilator lint_on UNUSEDSIGNAL */
/* verilator lint_on UNDRIVEN */
// --------------------------------------------------------------------
endinterface
