//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2015 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


interface
  axi4_if
  #(
    A=0,  // address bus width
    N=0,  // data bus width in bytes
    I=1 // ID width
  )
  (
    input           aresetn,
    input           aclk
  );

  wire [(A-1):0]    araddr;
  wire [1:0]        arburst;
  wire [3:0]        arcache;
  wire [(I-1):0]    arid;
  wire [7:0]        arlen;
  wire              arlock;
  wire [2:0]        arprot;
  wire [3:0]        arqos;
  wire              arready;
  wire [3:0]        arregion;
  wire [2:0]        arsize;
  wire              arvalid;
  wire [(A-1):0]    awaddr;
  wire [1:0]        awburst;
  wire [3:0]        awcache;
  wire [(I-1):0]    awid;
  wire [7:0]        awlen;
  wire              awlock;
  wire [2:0]        awprot;
  wire [3:0]        awqos;
  wire              awready;
  wire [3:0]        awregion;
  wire [2:0]        awsize;
  wire              awvalid;
  wire [(I-1):0]    bid;
  wire              bready;
  wire [1:0]        bresp;
  wire              bvalid;
  wire [(8*N)-1:0]  rdata;
  wire [(I-1):0]    rid;
  wire              rlast;
  wire              rready;
  wire [1:0]        rresp;
  wire              rvalid;
  wire [(8*N)-1:0]  wdata;
  wire [(I-1):0]    wid;
  wire              wlast;
  wire              wready;
  wire [N-1:0]      wstrb;
  wire              wvalid;


// --------------------------------------------------------------------
  // clocking cb_s @(posedge aclk);
    // input   arid;
    // input   araddr;
    // input   arburst;
    // input   arcache;
    // input   awid;
    // input   arlen;
    // input   arlock;
    // input   arprot;
    // input   arqos;
    // output  arready;
    // input   arregion;
    // input   arsize;
    // input   arvalid;
    // input   awaddr;
    // input   awburst;
    // input   awcache;
    // input   awlen;
    // input   awlock;
    // input   awprot;
    // input   awqos;
    // output  awready;
    // input   awregion;
    // input   awsize;
    // input   awvalid;
    // input   bready;
    // output  bid;
    // output  bresp;
    // output  bvalid;
    // output  rdata;
    // output  rid;
    // output  rlast;
    // input   rready;
    // output  rresp;
    // output  rvalid;
    // input   wdata;
    // input   wid;
    // input   wlast;
    // output  wready;
    // input   wstrb;
    // input   wvalid;
    // // input   aresetn;
    // // input   aclk;
  // endclocking


  // // --------------------------------------------------------------------
  // //
  // clocking cb_m @(posedge aclk);
    // output  arid;
    // output  araddr;
    // output  arburst;
    // output  arcache;
    // output  awid;
    // output  arlen;
    // output  arlock;
    // output  arprot;
    // output  arqos;
    // input   arready;
    // output  arregion;
    // output  arsize;
    // output  arvalid;
    // output  awaddr;
    // output  awburst;
    // output  awcache;
    // output  awlen;
    // output  awlock;
    // output  awprot;
    // output  awqos;
    // input   awready;
    // output  awregion;
    // output  awsize;
    // output  awvalid;
    // output  bready;
    // input   bid;
    // input   bresp;
    // input   bvalid;
    // input   rdata;
    // input   rid;
    // input   rlast;
    // output  rready;
    // input   rresp;
    // input   rvalid;
    // output  wdata;
    // output  wid;
    // output  wlast;
    // input   wready;
    // output  wstrb;
    // output  wvalid;
    // // input   aresetn;
    // // input   aclk;
  // endclocking
// // --------------------------------------------------------------------


  // // --------------------------------------------------------------------
  // //
// `ifdef USE_MOD_PORTS
  // // --------------------------------------------------------------------
  // //
    // modport
      // slave
      // (
// // --------------------------------------------------------------------
        // clocking  cb_s,
// // --------------------------------------------------------------------
        // input   arid,
        // input   araddr,
        // input   arburst,
        // input   arcache,
        // input   awid,
        // input   arlen,
        // input   arlock,
        // input   arprot,
        // input   arqos,
        // output  arready,
        // input   arregion,
        // input   arsize,
        // input   arvalid,
        // input   awaddr,
        // input   awburst,
        // input   awcache,
        // input   awlen,
        // input   awlock,
        // input   awprot,
        // input   awqos,
        // output  awready,
        // input   awregion,
        // input   awsize,
        // input   awvalid,
        // input   bready,
        // output  bid,
        // output  bresp,
        // output  bvalid,
        // output  rdata,
        // output  rid,
        // output  rlast,
        // input   rready,
        // output  rresp,
        // output  rvalid,
        // input   wdata,
        // input   wid,
        // input   wlast,
        // output  wready,
        // input   wstrb,
        // input   wvalid,
        // input   aresetn,
        // input   aclk
      // );


  // // --------------------------------------------------------------------
  // //
    // modport
      // master
      // (
// // --------------------------------------------------------------------
        // clocking  cb_m,
// // --------------------------------------------------------------------
        // output  arid,
        // output  araddr,
        // output  arburst,
        // output  arcache,
        // output  awid,
        // output  arlen,
        // output  arlock,
        // output  arprot,
        // output  arqos,
        // input   arready,
        // output  arregion,
        // output  arsize,
        // output  arvalid,
        // output  awaddr,
        // output  awburst,
        // output  awcache,
        // output  awlen,
        // output  awlock,
        // output  awprot,
        // output  awqos,
        // input   awready,
        // output  awregion,
        // output  awsize,
        // output  awvalid,
        // output  bready,
        // input   bid,
        // input   bresp,
        // input   bvalid,
        // input   rdata,
        // input   rid,
        // input   rlast,
        // output  rready,
        // input   rresp,
        // input   rvalid,
        // output  wdata,
        // output  wlast,
        // input   wready,
        // output  wstrb,
        // output  wvalid,
        // input   aresetn,
        // input   aclk
      // );
// `endif


// // --------------------------------------------------------------------
  // task
    // zero_cycle_delay;

    // ##0;

  // endtask: zero_cycle_delay
// // --------------------------------------------------------------------

  // // --------------------------------------------------------------------
  // typedef struct packed {
    // logic [(A-1):0]    addr;
  // } axi4_lite_ar_s;
    
  // typedef struct packed {
    // logic [(A-1):0]    addr;
  // } axi4_lite_aw_s;
    
  // typedef struct packed {
    // logic [1:0]        resp;
  // } axi4_lite_b_s;
    
  // typedef struct packed {
    // logic [(8*N)-1:0]  data;
    // logic [1:0]        resp;
  // } axi4_lite_r_s;
    
  // typedef struct packed {
    // logic [(8*N)-1:0]  data;
    // logic [N-1:0]      strb;
  // } axi4_lite_w_s;
  
  // // --------------------------------------------------------------------
  // axi4_lite_ar_s ar;
  // assign ar.addr = araddr;
  // wire [$bits(axi4_lite_ar_s)-1:0] ar_flat;
  // assign ar_flat = ar;
  
  // axi4_lite_aw_s aw;
  // assign aw.addr = awaddr;
  // wire [$bits(axi4_lite_aw_s)-1:0] aw_flat;
  // assign aw_flat = aw;
  
  // axi4_lite_b_s b;
  // assign b.resp = bresp;
  // wire [$bits(axi4_lite_b_s)-1:0] b_flat;
  // assign b_flat = b;
  
  // axi4_lite_r_s r;
  // assign r.data = rdata;
  // assign r.resp = rresp;
  // wire [$bits(axi4_lite_r_s)-1:0] r_flat;
  // assign r_flat = r;
  
  // axi4_lite_w_s w;
  // assign w.data = wdata;
  // assign w.strb = wstrb;
  // wire [$bits(axi4_lite_w_s)-1:0] w_flat;
  // assign w_flat = w;

// --------------------------------------------------------------------
endinterface

