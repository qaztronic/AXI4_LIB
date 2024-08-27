// --------------------------------------------------------------------
// Copyright 2024 qaztronic
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

import axi4_lite_piker_bfm_pkg::*;

interface axi4_lite_piker_bfm_if #(A=0, N=0)
( input   aclk
, input   aresetn
);
  // --------------------------------------------------------------------
  logic [    A-1:0] araddr  = 'x;
  logic             arvalid =  0;
  logic [    A-1:0] awaddr  = 'x;
  logic             awvalid =  0;
  logic             bready  =  0;
  logic             rready  =  0;
  logic [(N*8)-1:0] wdata   = 'x;
  logic [    N-1:0] wstrb   = 'x;
  logic             wvalid  =  0;

  wire              arready;
  wire              awready;
  wire [1:0]        bresp  ;
  wire              bvalid ;
  wire [(8*N)-1:0]  rdata  ;
  wire [1:0]        rresp  ;
  wire              rvalid ;
  wire              wready ;

  // --------------------------------------------------------------------
  clocking cb @(posedge aclk);
    input  arready;
    input  awready;
    input  bresp  ;
    input  bvalid ;
    input  rdata  ;
    input  rresp  ;
    input  rvalid ;
    input  wready ;
    output araddr ;
    output arvalid;
    output awaddr ;
    output awvalid;
    output bready ;
    output rready ;
    output wdata  ;
    output wstrb  ;
    output wvalid ;
  endclocking

// --------------------------------------------------------------------
endinterface
