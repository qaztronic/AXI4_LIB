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
logic [    C.A-1:0] araddr  = 'x;
logic               arvalid =  0;
logic [    C.A-1:0] awaddr  = 'x;
logic               awvalid =  0;
logic               bready  =  0;
logic               rready  =  0;
logic [(C.N*8)-1:0] wdata   = 'x;
logic [    C.N-1:0] wstrb   = 'x;
logic               wvalid  =  0;

assign axi4_s.araddr  = araddr ;
assign axi4_s.arvalid = arvalid;
assign axi4_s.awaddr  = awaddr ;
assign axi4_s.awvalid = awvalid;
assign axi4_s.bready  = bready ;
assign axi4_s.rready  = rready ;
assign axi4_s.wdata   = wdata  ;
assign axi4_s.wstrb   = wstrb  ;
assign axi4_s.wvalid  = wvalid ;

// --------------------------------------------------------------------
task axi4_lite_read
( input  [    C.A-1:0] addr
, output [(C.N*8)-1:0] data
);
  @(negedge aclk);
  araddr  = addr;
  arvalid = 1;

  wait(axi4_s.arready);
  @(negedge aclk);
  araddr  = 'x;
  arvalid = 0;

  wait(axi4_s.rvalid);
  @(negedge aclk);
  data = axi4_s.rdata;
  $display("[%0t] axi4_lite_read  @ araddr: %x | rdata: %x", $time, addr, axi4_s.rdata);
  rready = 1;

  @(negedge aclk);
  rready = 0;
endtask

// --------------------------------------------------------------------
task axi4_lite_write
( input [    C.A-1:0] addr
, input [(C.N*8)-1:0] data
);
  @(negedge aclk);
  awaddr  = addr;
  awvalid = 1   ;
  wdata   = data;
  wvalid  = 1   ;

  fork
    begin
      wait(axi4_s.awready);
      @(negedge aclk);
      awaddr = 'x;
      awvalid = 0;
    end
    begin
      wait(axi4_s.wready);
      @(negedge aclk);
      wdata = 'x;
      wvalid = 0;
    end
  join

  wait(axi4_s.bvalid);
  @(negedge aclk);
  $display("[%0t] axi4_lite write @ awaddr: %x | wdata: %x", $time, addr, data);
  bready = 1;

  @(negedge aclk);
  bready = 0;
endtask
