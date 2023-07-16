// --------------------------------------------------------------------
// Copyright 2021 qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”)
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

module axi4_lite_alias
( axi4_if axi4_s
, axi4_if axi4_m
);
  // --------------------------------------------------------------------
  assign axi4_m.araddr   = axi4_s.araddr  ;
  assign axi4_m.arburst  = axi4_s.arburst ;
  assign axi4_m.arcache  = axi4_s.arcache ;
  assign axi4_m.arid     = axi4_s.arid    ;
  assign axi4_m.arlen    = axi4_s.arlen   ;
  assign axi4_m.arlock   = axi4_s.arlock  ;
  assign axi4_m.arprot   = axi4_s.arprot  ;
  assign axi4_m.arqos    = axi4_s.arqos   ;
  assign axi4_m.arregion = axi4_s.arregion;
  assign axi4_m.arsize   = axi4_s.arsize  ;
  assign axi4_m.arvalid  = axi4_s.arvalid ;
  assign axi4_m.awaddr   = axi4_s.awaddr  ;
  assign axi4_m.awburst  = axi4_s.awburst ;
  assign axi4_m.awcache  = axi4_s.awcache ;
  assign axi4_m.awid     = axi4_s.awid    ;
  assign axi4_m.awlen    = axi4_s.awlen   ;
  assign axi4_m.awlock   = axi4_s.awlock  ;
  assign axi4_m.awprot   = axi4_s.awprot  ;
  assign axi4_m.awqos    = axi4_s.awqos   ;
  assign axi4_m.awregion = axi4_s.awregion;
  assign axi4_m.awsize   = axi4_s.awsize  ;
  assign axi4_m.awvalid  = axi4_s.awvalid ;
  assign axi4_m.bready   = axi4_s.bready  ;
  assign axi4_m.rready   = axi4_s.rready  ;
  assign axi4_m.wdata    = axi4_s.wdata   ;
  assign axi4_m.wid      = axi4_s.wid     ;
  assign axi4_m.wlast    = axi4_s.wlast   ;
  assign axi4_m.wstrb    = axi4_s.wstrb   ;
  assign axi4_m.wvalid   = axi4_s.wvalid  ;

  // --------------------------------------------------------------------
  assign axi4_s.arready = axi4_m.arready;
  assign axi4_s.awready = axi4_m.awready;
  assign axi4_s.bid     = axi4_m.bid    ;
  assign axi4_s.bresp   = axi4_m.bresp  ;
  assign axi4_s.bvalid  = axi4_m.bvalid ;
  assign axi4_s.rdata   = axi4_m.rdata  ;
  assign axi4_s.rid     = axi4_m.rid    ;
  assign axi4_s.rlast   = axi4_m.rlast  ;
  assign axi4_s.rresp   = axi4_m.rresp  ;
  assign axi4_s.rvalid  = axi4_m.rvalid ;
  assign axi4_s.wready  = axi4_m.wready ;

// --------------------------------------------------------------------
endmodule
