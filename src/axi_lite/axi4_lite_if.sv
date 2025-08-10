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
  /* verilator lint_off UNUSEDSIGNAL */
  wire [C.N-1:0] wstrb;
  /* verilator lint_on UNUSEDSIGNAL */

  generate
    if(C.USE_STRB == 0)
    begin : strb
      assign wstrb = 0;
    end
  endgenerate

  // --------------------------------------------------------------------
  /* verilator lint_off UNUSEDSIGNAL */
  wire [2:0] arprot;
  wire [2:0] awprot;
  /* verilator lint_on UNUSEDSIGNAL */

  generate
    if(C.USE_PROT == 0)
    begin : prot
      assign arprot = 0;
      assign awprot = 0;
    end
  endgenerate

  // --------------------------------------------------------------------
  /* verilator lint_off ASCRANGE */
  /* verilator lint_off UNUSEDSIGNAL */
  wire [C.I-1:0] arid;
  wire [C.I-1:0] awid;
  wire [C.I-1:0] bid ;
  wire [C.I-1:0] rid ;
  wire [C.I-1:0] wid ;
  /* verilator lint_on ASCRANGE */
  /* verilator lint_on UNUSEDSIGNAL */

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

  // -----------------------------------------------------------------------------
  /* verilator lint_off UNUSEDSIGNAL */
  clocking cb_s @(posedge aclk);
    input   araddr;
    input   awid;
    output  arready;
    input   arvalid;
    input   awaddr;
    output  awready;
    input   awvalid;
    input   bready;
    output  bid;
    output  bresp;
    output  bvalid;
    output  rdata;
    output  rid;
    input   rready;
    output  rresp;
    output  rvalid;
    input   wdata;
    input   wid;
    output  wready;
    input   wstrb;
    input   wvalid;
    input   aresetn;
    input   aclk;
  endclocking
  /* verilator lint_on UNUSEDSIGNAL */

// --------------------------------------------------------------------
endinterface
