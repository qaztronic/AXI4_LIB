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

import axi4_lite_pkg::*;

interface axi4_lite_if #(axi4_lite_cfg_t CONFIG)
( input aclk
, input aresetn
);
  // --------------------------------------------------------------------
  localparam int A = CONFIG.A > 0 ? CONFIG.A : 1;
  localparam int N = CONFIG.N > 0 ? CONFIG.N : 1;
  localparam int I = CONFIG.I > 0 ? CONFIG.I : 1;

  // --------------------------------------------------------------------
  wire [    A-1:0] araddr ;
  wire [    I-1:0] arid   ;
  wire [      2:0] arprot ;
  wire             arready;
  wire             arvalid;
  wire [    A-1:0] awaddr ;
  wire [    I-1:0] awid   ;
  wire [      2:0] awprot ;
  wire             awready;
  wire             awvalid;
  wire [    I-1:0] bid    ;
  wire             bready ;
  wire [      1:0] bresp  ;
  wire             bvalid ;
  wire [(8*N)-1:0] rdata  ;
  wire [    I-1:0] rid    ;
  wire             rready ;
  wire [      1:0] rresp  ;
  wire             rvalid ;
  wire [(8*N)-1:0] wdata  ;
  wire [    I-1:0] wid    ;
  wire             wready ;
  wire [    N-1:0] wstrb  ;
  wire             wvalid ;

  // --------------------------------------------------------------------
  generate
    if(CONFIG.USE_PROT == 0)
    begin : prot
      assign arprot = 0;
      assign awprot = 0;
    end
  endgenerate

  // --------------------------------------------------------------------
  generate
    if(CONFIG.I < 1)
    begin : id
      assign arid = 0;
      assign awid = 0;
      assign bid  = 0;
      assign rid  = 0;
      assign wid  = 0;
    end
  endgenerate

// --------------------------------------------------------------------
endinterface
